import Foundation
import Combine

@available(iOS 13.0, *)
extension Publisher {
	func wait(for semaphore: DispatchSemaphore, timeout: DispatchTime = .distantFuture) -> Publishers.WaitSemaphorePublisher<Self> {
		.init(
			upstream: self,
			semaphore: semaphore,
			timeout: timeout
		)
	}
}

@available(iOS 13.0, *)
extension Publishers.WaitSemaphorePublisher {
	enum Error: Swift.Error {
		case timedOut(DispatchTime)
	}
}

@available(iOS 13.0, *)
extension Publishers {
	class WaitSemaphorePublisher <Upstream: Publisher>: Publisher {
		typealias Output = Upstream.Output
		typealias Failure = Swift.Error

		let upstream: Upstream

		let semaphore: DispatchSemaphore
		let timeout: DispatchTime

		init (
			upstream: Upstream,
			semaphore: DispatchSemaphore,
			timeout: DispatchTime
		) {
			self.upstream = upstream
			self.semaphore = semaphore
			self.timeout = timeout
		}

		public func receive <Downstream: Subscriber> (subscriber: Downstream)
		where Downstream.Input == Output, Downstream.Failure == Swift.Error {
			let inner = Inner(
				downstream: subscriber,
				semaphore: semaphore,
				timeout: timeout
			)

			upstream.subscribe(inner)
		}
	}
}

@available(iOS 13.0, *)
extension Publishers.WaitSemaphorePublisher {
	final class Inner <Downstream: Subscriber>
	where Downstream.Input == Output, Downstream.Failure == Swift.Error {
		typealias Input = Upstream.Output
		typealias Failure = Upstream.Failure

		let downstream: Downstream

		let semaphore: DispatchSemaphore
		let timeout: DispatchTime
		var state = SubscriptionStatus.awaitingSubscription

		init (
			downstream: Downstream,
			semaphore: DispatchSemaphore,
			timeout: DispatchTime
		) {
			self.downstream = downstream
			self.semaphore = semaphore
			self.timeout = timeout
		}
	}
}

@available(iOS 13.0, *)
extension Publishers.WaitSemaphorePublisher.Inner: Subscriber {
	func receive (subscription: Subscription) {
		state = .subscribed(subscription)
		downstream.receive(subscription: self)
	}

	func receive (_ input: Input) -> Subscribers.Demand {
		guard case .subscribed = state else { return .none }

		switch semaphore.wait(timeout: timeout) {
		case .success:
			_receive(input)

		case .timedOut:
			downstream.receive(completion: .failure(Publishers.WaitSemaphorePublisher<Upstream>.Error.timedOut(timeout)))
		}

		return .none
	}

	private func _receive (_ input: Input) {
		guard let subscription = state.subscription else { return }
		let newDemand = downstream.receive(input)

		guard newDemand != .none else { return }
		subscription.request(newDemand)
	}

	func receive (completion: Subscribers.Completion<Failure>) {
		state = .terminal
		semaphore.signal()

		switch completion {
		case .finished: downstream.receive(completion: .finished)
		case .failure(let error): downstream.receive(completion: .failure(error))
		}
	}
}

@available(iOS 13.0, *)
extension Publishers.WaitSemaphorePublisher.Inner: Subscription {
	func request (_ demand: Subscribers.Demand) {
		guard case let .subscribed(subscription) = state else { return }
		subscription.request(demand)
	}

	func cancel () {
		guard case let .subscribed(subscription) = state else { return }
		state = .terminal
		subscription.cancel()
	}
}

@available(iOS 13.0, *)
extension Publishers.WaitSemaphorePublisher {
	enum SubscriptionStatus {
		case awaitingSubscription
		case subscribed(Subscription)
		case pendingTerminal(Subscription)
		case terminal

		var isAwaitingSubscription: Bool {
			switch self {
			case .awaitingSubscription:
				return true
			default:
				return false
			}
		}

		var subscription: Subscription? {
			switch self {
			case .awaitingSubscription, .terminal:
				return nil
			case let .subscribed(subscription), let .pendingTerminal(subscription):
				return subscription
			}
		}
	}
}
