//
//  APIError.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 16/12/23.
//

import Foundation

enum APIError: Error {
    case unknown
    case unreachable
    case unauthorized
    case failedRequest
    case invalidResponse
}
