//
//  EpisodeView.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 17/12/23.
//

import SwiftUI

struct EpisodeView: View {

    let viewModel: EpisodeViewModel

    @State private var showVideo = false

    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            
            Text(viewModel.title)
                .font(.title)
                .fontWeight(.thin)

            CapsuleButton(title: "Play Episode") {
                showVideo.toggle()
            }
            .sheet(isPresented: $showVideo) {
                VideoView(
                    viewModel: VideoViewModel(
                        videoID: viewModel.videoID,
                        apiService: APIClient(
                            accessTokenProvider: KeychainService()
                        )
                    )
                )
            }

            Text(viewModel.excerpt).padding()
            
            Spacer()
        }
    }
}

#if DEBUG
struct EpisodeView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeView(viewModel: EpisodeViewModel(episode: Episode.episodes[0]))
    }
}
#endif
