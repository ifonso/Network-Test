//
//  SignInViewModel.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 17/12/23.
//

import Foundation
import Combine

final class SignInViewModel: ObservableObject {
    
    // MARK: State
    
    @Published var email = ""
    @Published var password = ""
    
    @Published private(set) var isSigningIn = false
    @Published private(set) var errorMessage: String? = nil
    
    // MARK: Services
    
    private let apiService: APIService
    private let keychainService: KeychainService
    
    private var cancellables = Set<AnyCancellable>()
    
    var canSignIn: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    init(apiService: APIService, keychainService: KeychainService) {
        self.apiService = apiService
        self.keychainService = keychainService
    }
    
    // MARK: - Public API
    
    func signIn() {
        guard canSignIn else { return }
        
        isSigningIn = true
        errorMessage = nil
        
        apiService.signIn(email: email, password: password)
            .sink { [weak self] completion in
                self?.password = ""
                self?.isSigningIn = false
                
                switch completion {
                case .finished: ()
                case .failure(let error):
                    self?.errorMessage = APIErrorMapper(error: error, context: .signIn).message
                }
                
            } receiveValue: { [weak self] response in
                self?.keychainService.setAccessToken(response.accessToken)
                self?.keychainService.setRefreshToken(response.refreshToken)
            }
            .store(in: &cancellables)
    }
}
