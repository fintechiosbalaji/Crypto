//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24.
//

import SwiftUI
import LocalAuthentication

@main
struct CryptoAppApp: App {
    
    @StateObject private var dataController = DataController()
    @State private var selectedMode = 1
    
    @AppStorage("isLoggedIn")
    private var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            MainView() .environment(\.managedObjectContext, dataController.container.viewContext) .preferredColorScheme(.dark)
        }
    }
}


struct MainView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var showBiometricPrompt = true

    var body: some View {
        Group {
            if isLoggedIn {
                if showBiometricPrompt {
                    BiometricAuthView { success in
                        if success {
                            showBiometricPrompt = false
                        } else {
                            // Handle failed authentication (e.g., show alert)
                        }
                    }
                } else {
                    TabViewRouter.composeView()
                }
            } else {
                NavigationView {
                    let router = WelcomeRouter()
                    let interactor = WelcomeInteractor()
                    let presenter = WelcomePresenter(interactor: interactor, router: router)
                    WelcomeView(presenter: presenter)
                }
            }
        }
    }
}

struct BiometricAuthView: View {
    var onCompletion: (Bool) -> Void

    var body: some View {
        VStack {
            Text("Authenticating...")
                .font(.headline)
                .padding()
                .onAppear {
                    authenticateUser()
                }
        }
    }

    private func authenticateUser() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access the app"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    onCompletion(success)
                }
            }
        } else {
            DispatchQueue.main.async {
                onCompletion(false)
            }
        }
    }
}
struct MainView1: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    var body: some View {
        Group {
            if isLoggedIn {
                TabViewRouter.composeView()
                  
            } else {
                NavigationView {
                    let router = WelcomeRouter()
                    let interactor = WelcomeInteractor()
                    let presenter = WelcomePresenter(interactor: interactor, router: router)
                    WelcomeView(presenter: presenter)
                }
            }
        }
    }
}

