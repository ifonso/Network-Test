//
//  ProfileViewModel.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 17/12/23.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {

    @Published private(set) var isSignedIn = false

    let keychainService: KeychainService

    init(keychainService: KeychainService) {
        self.keychainService = keychainService
        setupBindings()
    }

    // MARK: - Public API

    func signOut() {
        keychainService.resetAccessToken()
        keychainService.resetRefreshToken()
    }
    
    // MARK: - Helper Methods
    
    private func setupBindings() {
        keychainService.$accessTokenPublisher
            .map { $0 != nil }
            .assign(to: &$isSignedIn)
    }
}
