//
//  RootView.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 16/12/23.
//

import SwiftUI

struct RootView: View {

    private let keychainService = KeychainService()
    
    var body: some View {
        TabView {
            EpisodesView(viewModel: EpisodesViewModel(
                apiService: APIClient(accessTokenProvider: keychainService)
            ))
            .tabItem {
                Label("What's New", systemImage: "film")
            }
            
            ProfileView(viewModel: ProfileViewModel(keychainService: keychainService))
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
#endif
