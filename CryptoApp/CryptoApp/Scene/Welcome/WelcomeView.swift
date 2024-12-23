//
//  WelcomeView.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI

struct WelcomeView: View, WelcomeViewProtocol {
    
    @ObservedObject
    private var presenter: WelcomePresenter
    @EnvironmentObject var authService:AuthService
    @Environment(\.colorScheme) var colorScheme
    
    init(presenter: WelcomePresenter) {
        self.presenter = presenter
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Image("crypto")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Text(presenter.getWelcomeData().welcomeText.localizedKey)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding()
                
                Text(presenter.getWelcomeData().descriptionText.localizedKey)
                    .multilineTextAlignment(.center)
                    .fontWeight(.light)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding()
                
                NavigationLink(destination: presenter.router.navigateToLoginIn()) {
                    Text(LocalizationKeys.Welcome.getStarted.localizedKey)
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(colorScheme == .dark ? .orange : .orange)
                        .cornerRadius(20)
                        .padding(24)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("primaryColor"))
        }.navigationViewStyle(StackNavigationViewStyle())
        .modifier(DarkModeViewModifier())
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeRouter.composeView()
    }
}
