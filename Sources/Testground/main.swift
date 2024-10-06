import NetworkUtil
import Foundation

StandardURLClient()
	.repeatable(maxAttempts: 10)
	.configuration {
		$0.addInfo(key: .maxRepeatAttemptCount, value: 0)
	}
	.setDelegate(.standard())
