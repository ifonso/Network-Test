//
//  EpisodesView.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 17/12/23.
//

import SwiftUI

struct EpisodesView: View {

    @ObservedObject var viewModel: EpisodesViewModel

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isFetching {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                    } else {
                        List(viewModel.episodeRowViewModels) { viewModel in
                            NavigationLink {
                                EpisodeView(
                                    viewModel: EpisodeViewModel(
                                        episode: viewModel.episode
                                    )
                                )
                            } label: {
                                EpisodeRowView(viewModel: viewModel)
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("What's New")
        }
    }
}

struct EpisodesView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodesView(viewModel: EpisodesViewModel(apiService: APIPreviewClient()))
    }
}
