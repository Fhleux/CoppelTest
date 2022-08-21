//
//  HomeViewModel.swift
//  coppelTest
//
//  Created by Tony on 8/18/22.
//

import Foundation
import Combine

final class HomeViewModel {
    
    @Published var movies = [Movie]()
    
    func logout() {
        LocalSettings.request_token = nil
    }
    
    func fetchData() async  {
        do {
            let fetchMovies = try await NetworkManager.sharedInstance.getMovies()
            DispatchQueue.main.async {
                self.movies = fetchMovies
            }
        }  catch let parseError {
            print(parseError.localizedDescription)
        }
    }
    
}
