//
//  KeychainService.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 16/12/23.
//

import Combine
import Foundation
import KeychainAccess

final class KeychainService: AccessTokenProvider {

    private enum Keys {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
    }

    private let storage = Keychain(service: "com.afonso.script.sol.cocoacasts")
    
    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Access Token
    @Published private(set) var accessTokenPublisher: String?

    var accessToken: String? {
        accessTokenPublisher
    }

    func setAccessToken(_ accessToken: String) {
        accessTokenPublisher = accessToken
    }

    func resetAccessToken() {
        accessTokenPublisher = nil
    }

    // MARK: - Refresh Token
    @Published private(set) var refreshTokenPublisher: String?

    var refreshToken: String? {
        refreshTokenPublisher
    }

    func setRefreshToken(_ refreshToken: String) {
        refreshTokenPublisher = refreshToken
    }

    func resetRefreshToken() {
        refreshTokenPublisher = nil
    }

    init() {
        accessTokenPublisher = storage[Keys.accessToken]
        refreshTokenPublisher = storage[Keys.refreshToken]

        setupBindings()
    }

    // MARK: - Helper Methods
    private func setupBindings() {
        $accessTokenPublisher
            .sink { _ in () } receiveValue: { [weak self] token in
                if let accessToken = token {
                    self?.storage[Keys.accessToken] = accessToken
                } else {
                    do {
                        try self?.storage.remove(Keys.accessToken)
                    } catch {
                        print("Unable to Remove Access Token from Keychain \(error)")
                    }
                }
            }
            .store(in: &subscriptions)

        $refreshTokenPublisher
            .sink { _ in () } receiveValue: { [weak self] token in
                if let refreshToken = token {
                    self?.storage[Keys.refreshToken] = refreshToken
                } else {
                    do {
                        try self?.storage.remove(Keys.refreshToken)
                    } catch {
                        print("Unable to Remove Refresh Token from Keychain \(error)")
                    }
                }
            }
            .store(in: &subscriptions)
    }
}

