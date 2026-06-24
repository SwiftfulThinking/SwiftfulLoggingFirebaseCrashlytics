import Foundation
import FirebaseCrashlytics
import FirebaseCrashlyticsSwift
import SwiftfulLogging

public struct FirebaseCrashlyticsService: LogService {
    
    public init() {
        
    }

    public func trackEvent(event: LoggableEvent) {
        // Records the event as a non-fatal error. Type routing is handled by the
        // caller (LogManager only forwards a service its allowed types — typically
        // just `.severe`), so this service no longer filters by type itself.
        //
        // Note: Firebase Analytics automatically logs breadcrumbs to Crashlytics,
        // so non-severe events don't need to be sent here.
        // https://firebase.google.com/docs/crashlytics/customize-crash-reports?platform=ios#get-breadcrumb-logs
        let error = NSError(
            domain: event.eventName,
            code: event.eventName.stableHashValue,
            userInfo: event.parameters
        )
        Crashlytics.crashlytics().record(error: error, userInfo: event.parameters)
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

    public func addUserProperties(dict: [String: Any], isHighPriority: Bool) {
        // Sets every received custom key/value. Firebase Crashlytics allows up to
        // 64 pairs, so callers should route only high-priority properties here
        // (LogManager handles that); this service no longer filters by
        // isHighPriority itself.
        // https://firebase.google.com/docs/crashlytics/customize-crash-reports?platform=ios
        for attribute in dict {
            Crashlytics.crashlytics().setCustomValue(attribute.value, forKey: attribute.key)
        }
    }

    public func deleteUserProfile() {
        Crashlytics.crashlytics().setUserID("new")
    }

}
