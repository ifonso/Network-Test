//
//  AccessTokenProvider.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 16/12/23.
//

import Foundation

protocol AccessTokenProvider {
    var accessToken: String? { get }
}
