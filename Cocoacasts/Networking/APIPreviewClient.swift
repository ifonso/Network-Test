//
//  APIPreviewClient.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 17/12/23.
//

import Foundation
import Combine

final class APIPreviewClient: APIService {
    
    func signIn(email: String, password: String) -> AnyPublisher<SignInResponse, APIError> {
        Just(
            SignInResponse(accessToken: "123", refreshToken: "456")
        )
        .setFailureType(to: APIError.self)
        .eraseToAnyPublisher()
    }
    
    func episodes() -> AnyPublisher<[Episode], APIError> {
        publisher(for: "episodes")
    }
    
    func video(id: String) -> AnyPublisher<Video, APIError> {
       publisher(for: "video")
    }
    
    func progressForVideo(id: String) -> AnyPublisher<VideoProgressResponse, APIError> {
        publisher(for: "video-progress")
    }
    
    func updateProgressForVideo(id: String, cursor: Int) -> AnyPublisher<VideoProgressResponse, APIError> {
        publisher(for: "video-progress")
    }
    
    func deleteProgressForVideo(id: String) -> AnyPublisher<Empty, APIError> {
        Just(Empty())
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
}

extension APIPreviewClient {
    
    func publisher<T: Decodable>(for resource: String) -> AnyPublisher<T, APIError> {
        Just(stubData(for: resource))
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
    
    func stubData<T: Decodable>(for resource: String) -> T {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(T.self, from: data)
        else { fatalError("Unable to Load Stub Data") }
        return decoded
    }
}
