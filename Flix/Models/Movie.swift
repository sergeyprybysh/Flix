//
//  Movie.swift
//  Flix
//
//  Created by Sergey Prybysh on 9/24/20.
//

import Foundation

struct Movie: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case posterPath = "poster_path"
    }
    
    let title: String
    let overview: String
    let posterPath: String
}
