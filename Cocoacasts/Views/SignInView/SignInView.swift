//
//  SignInView.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 17/12/23.
//

import SwiftUI

struct SignInView: View {

    @ObservedObject var viewModel: SignInViewModel

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Error label
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .fontWeight(.light)
                                .foregroundColor(.accentColor)
                        }
                        
                        // Email camp
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .fontWeight(.light)
                            TextField("Email", text: $viewModel.email)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        
                        // Password camp
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .fontWeight(.light)
                            SecureField("Password", text: $viewModel.password)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                    }
                    
                    CapsuleButton(title: "Sign In") {
                        viewModel.signIn()
                    }
                    .disabled(!viewModel.canSignIn)
                    
                    Spacer()
                }
                .padding()
                .textFieldStyle(.roundedBorder)

                if viewModel.isSigningIn {
                    ZStack {
                        Color(white: 1.0).opacity(0.75)
                        ProgressView().progressViewStyle(.circular)
                    }
                }
            }
            .navigationTitle("Sign In")
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: .init(apiService: APIPreviewClient(),
                                    keychainService: KeychainService()))
    }
}
