//
//  LoginViewModel.swift
//  coppelTest
//
//  Created by Tony on 8/17/22.
//

import Foundation
import Combine

final class LoginViewModel {
    
    @Published var error: String?
    @Published var request_token: String?
    
    private var user: User?
    
    func login(username: String, password: String) async {
        
        do {
            let token = try await NetworkManager.sharedInstance.requestTokenAsync()
            let loginSuccess = try await NetworkManager.sharedInstance.createSessionWithLogin(username: username, password: password)
            let (requestSuccess, requestMessage) = loginSuccess
            LocalSettings.request_token = requestSuccess ? token : nil
            DispatchQueue.main.async {
                self.error = requestSuccess ? nil : requestMessage
                self.request_token = requestSuccess ? token : nil
            }
        } catch let parseError {
            print(parseError.localizedDescription)
        }
        
    }
    
    func checkToken() -> Bool {
        if let _ = LocalSettings.request_token { return true } else { return false }
    }
     
}
