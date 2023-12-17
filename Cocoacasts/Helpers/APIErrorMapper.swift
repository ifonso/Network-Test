//
//  APIErrorMapper.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 16/12/23.
//

import Foundation

struct APIErrorMapper {

    enum Context {
        case signIn
        case episodes
        case video
    }

    let error: APIError
    let context: Context

    var message: String {
        switch error {
        case .unreachable:
            return "You need to have a network connection."

        case .unauthorized:
            switch context {
            case .video:
                return "You need to be signed in to watch this episode."
            default:
                return "You need to be signed in."
            }

        case .unknown, .failedRequest, .invalidResponse:
            switch context {
            case .signIn:
                return "The email/password combination is invalid."
            case .episodes:
                return "The list of episodes could not be fetched."
            case .video:
                return "The video could not be fetched."
            }
        }
    }

}
