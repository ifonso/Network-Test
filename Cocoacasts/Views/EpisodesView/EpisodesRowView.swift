//
//  EpisodesRowView.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 17/12/23.
//

import SwiftUI

struct EpisodeRowView: View {

    @ObservedObject var viewModel: EpisodeRowViewModel

    var body: some View {
        HStack(spacing: 8) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.title)
                    .font(.headline)
                    .fontWeight(.light)
                
                if let formattedVideoDuration = viewModel.formattedVideoDuration {
                    Text(formattedVideoDuration)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#if DEBUG
struct EpisodeRowView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeRowView(viewModel: EpisodeRowViewModel(episode: Episode.episodes[0]))
    }
}
#endif
