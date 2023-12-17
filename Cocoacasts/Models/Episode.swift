//
//  Episode.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 16/12/23.
//

import Foundation

struct Episode: Decodable {
    
    let id: Int
    let title: String
    let excerpt: String
    
    let imageURL: URL
    
    let videoID: String
    let videoDuration: Int
}

extension Episode {
    #if DEBUG
    static let episodes: [Episode] = {
        guard let url = Bundle.main.url(forResource: "episodes", withExtension: "json")
        else { fatalError("Unable to Find Stub Data") }
        
        guard let data = try? Data(contentsOf: url)
        else { fatalError("Unable to Load Stub Data") }
        
        return try! JSONDecoder().decode([Episode].self, from: data)
    }()
    #endif
}
