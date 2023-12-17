//
//  APIEndpoint.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 16/12/23.
//

import Foundation

enum APIEndpoint {
    
    case auth(email: String, password: String)
    case episodes
    case video(id: String)
    
    case videoProgress(id: String)
    case updateVideoProgress(id: String, cursor: Int)
    case deleteVideoProgress(id: String)
    
    private var url: URL {
        Environment.apiBaseURL.appendingPathComponent(path)
    }
    
    func request(accessToken: String?) throws -> URLRequest {
        var request = URLRequest(url: url)
        
        request.addHeaders(headers)
        request.httpMethod = httpMethod.rawValue
        
        if requiresAuthorization {
            guard let accessToken = accessToken else {
                throw APIError.unauthorized
            }
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = httpBody
        return request
    }
    
    private var path: String {
        switch self {
        case .auth: return "auth"
        case .episodes: return "episodes"
        case let .video(id: id):
            return "videos/\(id)"
        case let .videoProgress(id: id),
             let .updateVideoProgress(id: id, cursor: _),
             let .deleteVideoProgress(id: id):
            return "videos/\(id)/progress"
        }
    }
    
    private var httpMethod: HTTPMethod {
        switch self {
        case .auth, .updateVideoProgress:
            return .post
        case .episodes, .video, .videoProgress:
            return .get
        case .deleteVideoProgress:
            return .delete
        }
    }
    
    private var httpBody: Data? {
        switch self {
        case let .updateVideoProgress(id: _, cursor: cursor):
            let body = UpdateVideoProgressBody(cursor: cursor)
            return try? JSONEncoder().encode(body)
        default:
            return nil
        }
    }
    
    private var requiresAuthorization: Bool {
        switch self {
        case .auth, .episodes:
            return false
        case .video, .videoProgress, .updateVideoProgress, .deleteVideoProgress:
            return true
        }
    }
    
    private var headers: Headers {
        var headers: Headers = ["Content-Type": "application/json",
                                "X-API-TOKEN": Environment.apiToken]
        
        if case let .auth(email, password) = self {
            let authData = (email + ":" + password).data(using: .utf8)!
            let encodedAuthData = authData.base64EncodedString()
            headers["Authorization"] = "Basic \(encodedAuthData)"
        }
        
        return headers
    }
}

extension URLRequest {
    
    mutating func addHeaders(_ headers: Headers) {
        headers.forEach { header, value in
            self.addValue(value, forHTTPHeaderField: header)
        }
    }
}
