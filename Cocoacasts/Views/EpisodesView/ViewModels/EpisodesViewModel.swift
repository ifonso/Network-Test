//
//  EpisodesViewModel.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 17/12/23.
//

import Combine
import Foundation

final class EpisodesViewModel: ObservableObject {

    // MARK: State

    @Published private(set) var episodes: [Episode] = []

    @Published private(set) var isFetching = false
    @Published private(set) var errorMessage: String?

    var episodeRowViewModels: [EpisodeRowViewModel] {
        episodes.map { EpisodeRowViewModel(episode: $0) }
    }
    
    // MARK: Service

    private let apiService: APIService

    private var cancellables: Set<AnyCancellable> = []

    init(apiService: APIService) {
        self.apiService = apiService
        fetchEpisodes()
    }

    // MARK: - Helper Methods

    private func fetchEpisodes() {
        isFetching = true

        apiService.episodes()
            .sink { [weak self] completion in
                self?.isFetching = false

                switch completion {
                case .finished: ()
                case .failure(let error):
                    self?.errorMessage = APIErrorMapper(error: error, context: .episodes).message
                }
            } receiveValue: { [weak self] episodes in
                self?.episodes = episodes
            }
            .store(in: &cancellables)
    }
}

