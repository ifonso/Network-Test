//
//  VideoView.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 17/12/23.
//

import AVKit
import SwiftUI

struct VideoView: View {

    @ObservedObject var viewModel: VideoViewModel

    var body: some View {
        ZStack {
            Color.black
            
            if let player = viewModel.player {
                VideoPlayer(player: player)
            } else {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.white)
                } else {
                    ProgressView()
                        .tint(.white)
                        .progressViewStyle(.circular)
                }
            }
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
    }
}

#if DEBUG
struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(
            viewModel: VideoViewModel(
                videoID: Episode.episodes[0].videoID,
                apiService: APIPreviewClient()
            )
        )
    }
}
#endif
