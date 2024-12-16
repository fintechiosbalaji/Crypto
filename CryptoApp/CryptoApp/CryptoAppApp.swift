//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    
    @StateObject private var dataController = DataController()
    @State private var selectedMode = 1

    
    var body: some Scene {
        WindowGroup {
           // CurrencyConverterRouter.composeView()
            let router = WelcomeRouter()
            let interactor = WelcomeInteractor()
            let presenter = WelcomePresenter(interactor: interactor, router: router)
            WelcomeView(presenter: presenter)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .preferredColorScheme(.dark )
        }
    }
}
