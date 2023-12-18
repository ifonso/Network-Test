//
//  APIClient.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 16/12/23.
//

import Foundation
import Combine

final class APIClient: APIService {
    
    private let accessTokenProvider: AccessTokenProvider
    
    init(accessTokenProvider: AccessTokenProvider) {
        self.accessTokenProvider = accessTokenProvider
    }
    
    // MARK: - API Services
    func signIn(email: String, password: String) -> AnyPublisher<SignInResponse, APIError> {
        request(.auth(email: email, password: password))
    }
    
    func episodes() -> AnyPublisher<[Episode], APIError> {
        request(.episodes)
    }
    
    func video(id: String) -> AnyPublisher<Video, APIError> {
        request(.video(id: id))
    }
    
    func progressForVideo(id: String) -> AnyPublisher<VideoProgressResponse, APIError> {
        request(.videoProgress(id: id))
    }
    
    func updateProgressForVideo(id: String, cursor: Int) -> AnyPublisher<VideoProgressResponse, APIError> {
        request(.updateVideoProgress(id: id, cursor: cursor))
    }
    
    func deleteProgressForVideo(id: String) -> AnyPublisher<Empty, APIError> {
        request(.deleteVideoProgress(id: id))
    }
    
    // MARK: - Helper Methods
    private func request<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIError> {
        do {
            let accessToken = accessTokenProvider.accessToken
            let request = try endpoint.request(accessToken: accessToken)

            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { data, response -> T in
                    try self.handleResponse(data: data, response: response)
                }
                .mapError { error -> APIError in
                    switch error {
                    case let apiError as APIError:
                        return apiError
                    case URLError.notConnectedToInternet:
                        return APIError.unreachable
                    default:
                        return APIError.failedRequest
                    }
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error as! APIError)
                .eraseToAnyPublisher()
        }
    }
    
    private func handleResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw APIError.failedRequest
        }

        guard statusCode.isSuccess else {
            if statusCode == 401 {
                throw APIError.unauthorized
            } else {
                throw APIError.failedRequest
            }
        }
        
        if statusCode == 204, let empty = Empty() as? T {
            return empty
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.invalidResponse
        }
    }
}
