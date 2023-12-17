//
//  VideoViewModel.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 17/12/23.
//

import Combine
import Foundation
import AVFoundation

final class VideoViewModel: ObservableObject {

    // MARK: State
    
    @Published private(set) var player: AVPlayer?
    @Published private(set) var isFetching = false
    @Published private(set) var errorMessage: String?

    // MARK: Services
    
    private let apiService: APIService

    private var cancellables = Set<AnyCancellable>()

    init(videoID: String, apiService: APIService) {
        self.apiService = apiService
        fetchVideo(with: videoID)
    }

    // MARK: - Helper Methods

    private func fetchVideo(with videoID: String) {
        isFetching = true

        apiService.video(id: videoID)
            .sink { [weak self] completion in
                self?.isFetching = false

                switch completion {
                case .finished: ()
                case .failure(let error):
                    self?.errorMessage = APIErrorMapper(error: error, context: .video).message
                }
            } receiveValue: { [weak self] video in
                self?.player = AVPlayer(url: video.videoURL)
            }
            .store(in: &cancellables)

        apiService.deleteProgressForVideo(id: videoID)
            .sink { completion in
                print(completion)
            } receiveValue: { response in
                print(response)
            }
            .store(in: &cancellables)
    }
}
