//
//  Video.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 16/12/23.
//

import Foundation

struct Video: Decodable {
    
    let duration: Int
    
    let imageURL: URL
    let videoURL: URL
}
