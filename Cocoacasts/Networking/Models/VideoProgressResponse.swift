//
//  VideoProgressResponse.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 16/12/23.
//

import Foundation

struct VideoProgressResponse: Decodable {
    
    let cursor: Int
    let videoID: String
}
