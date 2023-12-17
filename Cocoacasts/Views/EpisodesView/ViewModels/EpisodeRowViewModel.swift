//
//  EpisodeRowViewModel.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 17/12/23.
//

import UIKit
import Combine
import Foundation

internal final class EpisodeRowViewModel: ObservableObject, Identifiable {

    let episode: Episode

    var id: Int {
        episode.id
    }

    var title: String {
        episode.title
    }

    @Published private(set) var image: UIImage?

    private(set) lazy var formattedVideoDuration: String? = {
        VideoDurationFormatter().string(
            from: TimeInterval(episode.videoDuration)
        )
    }()

    private var cloudinaryURL: URL {
        CloudinaryURLBuilder(source: episode.imageURL)
            .width(50)
            .height(50)
            .build()
    }

    init(episode: Episode) {
        self.episode = episode
        fetchImage()
    }

    // MARK: - Helper Methods

    private func fetchImage() {
        URLSession.shared.dataTask(with: cloudinaryURL) { [weak self] data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
        .resume()
    }
}

