//
//  ProfileViewModel.swift
//  coppelTest
//
//  Created by Tony on 8/19/22.
//

import Foundation
import Combine

final class ProfileViewModel {
    
    @Published var profile = User()
    
    func fetchProfile() async {
        do {
            guard let profileResponse = try await NetworkManager.sharedInstance.getProfile() else { return }
            DispatchQueue.main.async {
                self.profile = profileResponse
            }
        } catch let parseError {
            print(parseError.localizedDescription)
        }
        
    }
}
