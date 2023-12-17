//
//  ProfileView.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 17/12/23.
//

import SwiftUI

struct ProfileView: View {

    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        VStack {
            if viewModel.isSignedIn {
                VStack(spacing: 20.0) {
                    Text("You are signed in.")
                    
                    CapsuleButton(title: "Sign Out") {
                        viewModel.signOut()
                    }
                }
            } else {
                SignInView(
                    viewModel: SignInViewModel(
                        apiService: APIClient(accessTokenProvider: viewModel.keychainService),
                        keychainService: viewModel.keychainService
                    )
                )
            }
        }
    }

}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(
            viewModel: ProfileViewModel(
                keychainService: KeychainService()
            )
        )
    }
}
#endif
