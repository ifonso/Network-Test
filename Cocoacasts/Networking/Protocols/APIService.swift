//
//  APIService.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 16/12/23.
//

import Foundation
import Combine

protocol APIService {

    func signIn(email: String, password: String) -> AnyPublisher<SignInResponse, APIError>

    func episodes() -> AnyPublisher<[Episode], APIError>

    func video(id: String) -> AnyPublisher<Video, APIError>

    func progressForVideo(id: String) -> AnyPublisher<VideoProgressResponse, APIError>
    
    func updateProgressForVideo(id: String, cursor: Int) -> AnyPublisher<VideoProgressResponse, APIError>
    
    func deleteProgressForVideo(id: String) -> AnyPublisher<Empty, APIError>
}
