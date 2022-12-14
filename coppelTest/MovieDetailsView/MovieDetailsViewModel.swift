//
//  MovieDetailsViewModel.swift
//  coppelTest
//
//  Created by Tony on 8/20/22.
//

import Foundation
import Combine

final class MovieDetailsViewModel {
    
    @Published var movie = Movie()
    
    func fetchMovieDetals(_ id:Int) async {
        do {
            guard let movieDetails = try await NetworkManager.sharedInstance.getMovieDetails(id) else { return }
            DispatchQueue.main.async {
                self.movie = movieDetails
            }
        }
        catch let parseError {
            print(parseError.localizedDescription)
        }
    }
    
    func getCompanyImage(_ urlPath: String) async -> Data? {
        do {
            guard let companyImgData = try await NetworkManager.sharedInstance.downloadImage(urlPath) else { return nil }
            return companyImgData
        }
        catch let parseError {
            print(parseError.localizedDescription)
        }
        return nil
    }
}
