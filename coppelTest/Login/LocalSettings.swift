//
//  LocalSettings.swift
//  coppelTest
//
//  Created by Tony on 8/18/22.
//

import Foundation

class LocalSettings {
    
    static var sharedInstance = LocalSettings()
    private static let tokenKey = "request_token"
    private static let sessionId = "session_id"
    
    static var request_token: String? {
        get {
            guard let user = UserDefaults.standard.string(forKey: tokenKey) else {
                return nil
            }
            return user
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    
    static var session_id: String? {
        get {
            guard let id = UserDefaults.standard.string(forKey: sessionId) else {
                return nil
            }
            return id
        }
        set {
            UserDefaults.standard.set(newValue, forKey: sessionId)
        }
    }
}
