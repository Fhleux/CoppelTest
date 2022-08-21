//
//  Movies.swift
//  coppelTest
//
//  Created by Tony on 8/18/22.
//

import Foundation

public enum Filters: String {
    case popular
    case topRated
    case onTV
    case AiringToday
}

struct ProductionCompany {
    let id:Int
    let logo_path: String?
    let name:String
}

class Movie {
    var title, description, staus : String?
    var id, durarion: Int?
    var rating : Double?
    var releaseDate : Date?
    var imgdata: Data?
    var genres: [String]?
    var adult: Bool = false
    var productionCompanies: [ProductionCompany]?
    
    init(){}
    init(title: String, description: String, rating: Double, release: Date, id: Int) {
        self.title = title
        self.id = id
        self.description = description
        self.rating = rating
        self.releaseDate = release
    }
}
