import Foundation
import Combine

extension Publisher {
	func signal(_ semaphore: DispatchSemaphore) -> Publishers.SignalSemaphorePublisher<Self> {
		.init(
			upstream: self,
			semaphore: semaphore
		)
	}
}

extension Publishers {
	class SignalSemaphorePublisher <Upstream: Publisher>: Publisher {
		typealias Output = Upstream.Output
		typealias Failure = Upstream.Failure
		
		let upstream: Upstream
		
		let semaphore: DispatchSemaphore
		
		init (
			upstream: Upstream,
			semaphore: DispatchSemaphore
		) {
			self.upstream = upstream
			self.semaphore = semaphore
		}
		
		public func receive <Downstream: Subscriber> (subscriber: Downstream)
		where Downstream.Input == Output, Downstream.Failure == Failure
		{
			let inner = Inner(
				downstream: subscriber,
				semaphore: semaphore
			)
			
			upstream.subscribe(inner)
		}
	}
}

extension Publishers.SignalSemaphorePublisher {
	final class Inner <Downstream: Subscriber>
	where Downstream.Input == Output, Downstream.Failure == Failure
	{
		typealias Input = Upstream.Output
		typealias Failure = Upstream.Failure
		
		let downstream: Downstream
		
		let semaphore: DispatchSemaphore
		var state = SubscriptionStatus.awaitingSubscription
		
		init (
			downstream: Downstream,
			semaphore: DispatchSemaphore
		) {
			self.downstream = downstream
			self.semaphore = semaphore
		}
	}
}

extension Publishers.SignalSemaphorePublisher.Inner: Subscriber {
	func receive (subscription: Subscription) {
		state = .subscribed(subscription)
		downstream.receive(subscription: self)
	}
	
	func receive (_ input: Input) -> Subscribers.Demand {
		guard case .subscribed = state else { return .none }
		
		semaphore.signal()
		_receive(input)
		
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
		downstream.receive(completion: completion)
	}
}

extension Publishers.SignalSemaphorePublisher.Inner: Subscription {
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

extension Publishers.SignalSemaphorePublisher {
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
