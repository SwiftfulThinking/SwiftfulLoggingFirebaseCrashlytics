import Foundation
import FirebaseCrashlytics
import FirebaseCrashlyticsSwift
import SwiftfulLogging
import SendableDictionary

public struct FirebaseCrashlyticsService: LogService {
    
    public init() {
        
    }

    public func trackEvent(event: LoggableEvent) {
        // Note: Firebase Analytics automatically log breadcrumbs to Crashlytics
        // Therefore, no need to send typical events herein
        // https://firebase.google.com/docs/crashlytics/customize-crash-reports?hl=en&authuser=1&_gl=1*ntknz4*_ga*MTg3MDE4MjY5OC4xNzE3ODAzNTUw*_ga_CW55HF8NVT*MTcyOTg2MDMwNS42My4xLjE3Mjk4NjA2MTcuMjQuMC4w&platform=ios#get-breadcrumb-logs
        
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
        
        if let name {
            Crashlytics.crashlytics().setCustomValue("account_name", forKey: name)
        }
        if let email {
            Crashlytics.crashlytics().setCustomValue("account_email", forKey: email)
        }
    }

    public func addUserProperties(dict: SendableDict, isHighPriority: Bool) {
        // Firebase Crashlytics allows up to 64  key/value pairs
        // https://firebase.google.com/docs/crashlytics/customize-crash-reports?platform=ios
        
        guard isHighPriority else { return }
        for attribute in dict.dict {
            Crashlytics.crashlytics().setCustomValue(attribute.value, forKey: attribute.key)
        }
    }

    public func deleteUserProfile() {
        Crashlytics.crashlytics().setUserID("new")
    }

}
