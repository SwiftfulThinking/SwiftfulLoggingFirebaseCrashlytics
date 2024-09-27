import Foundation
import FirebaseCrashlytics
import FirebaseCrashlyticsSwift
import SwiftfulLogging
import SendableDictionary

public struct FirebaseCrashlyticsService: LogService {
    
    public init() {
        
    }

    public func trackEvent(event: LoggableEvent) {
        switch event.type {
        case .info, .analytic, .warning:
            break
        case .severe:
            let error = NSError(
                domain: event.eventName,
                code: event.eventName.stableHashValue,
                userInfo: event.parameters
            )
            Crashlytics.crashlytics().record(error: error, userInfo: event.parameters)
        }
    }

    public func trackScreenView(event: any LoggableEvent) {
        trackEvent(event: event)
    }

    public func identifyUser(userId: String, name: String?, email: String?) {
        Crashlytics.crashlytics().setUserID(userId)
        Crashlytics.crashlytics().setCustomValue("Profile Name", forKey: name ?? "unknown")
        Crashlytics.crashlytics().setCustomValue("Profile Email", forKey: email ?? "unknown")
    }

    public func addUserProperties(dict: SendableDict) {
        for attribute in dict.dict {
            Crashlytics.crashlytics().setCustomValue(attribute.value, forKey: attribute.key)
        }
    }

    public func deleteUserProfile() {
        Crashlytics.crashlytics().setUserID("new")
    }

}
