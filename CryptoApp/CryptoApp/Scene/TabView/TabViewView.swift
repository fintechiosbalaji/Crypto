//
//  TabViewView.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI
import CoreData

class NavigationState: ObservableObject {
    @Published var showProfileHeader: Bool = true
}

struct TabViewView: View, TabViewViewProtocol {
    
    @ObservedObject
    private var presenter: TabViewPresenter
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var context
    @State private var selectedTab = 0
  
    
    init(presenter: TabViewPresenter, selectedTab: Int) {
        self.presenter = presenter
        self.selectedTab = selectedTab
    }
    
    @StateObject private var navigationState = NavigationState()
    @State private var isLoggedIn = true
    
    var body: some View {
        VStack {
            if navigationState.showProfileHeader {
                ProfileHeaderView()
            }
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    switch selectedTab {
                    case 0:
                        LazyView(PortfolioRouter.composeView())
                            .tag(0)
                    case 1:
                        LazyView(MarketRouter.composeView())
                            .tag(1)
                    case 2:
                        LazyView(ManageCardsRouter.composeView(context: context))
                            .tag(2)
                    case 3:
                        LazyView(CurrencyConverterRouter.composeView())
                            .tag(3)
                    case 4:
                        LazyView(SettingsRouter.composeView())
                            .tag(4)
                    default:
                        Text("Unknown View")
                            .tag(-1)
                    }
                }
                .background(Color("primaryColor").ignoresSafeArea())
                CustomTabBar(selection: $selectedTab)
            }
        }
        .navigationBarBackButtonHidden(true)
        .primaryBackground()
    }
}

struct CustomTabBar: View {
    @Binding var selection: Int
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            ForEach(TabbedItems.allCases, id: \.self) { item in
                Button(action: {
                    selection = item.rawValue
                }) {
                    Text("")
                        .customTabItem(imageName: item.iconName, title: item.title, isActive: (selection == item.rawValue))
                }
            }
        }
        .padding(6)
        .frame(height: 70)
        .background(colorScheme == .dark ? Color.purple.opacity(0.3) : Color.gray.opacity(0.3))
        .cornerRadius(35)
        .padding(.horizontal, 5)
    }
}

struct TabViewView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewRouter.composeView()
    }
}

class AuthService: ObservableObject {
    @Published var signedIn:Bool
    
    init(signedIn:Bool) {
        self.signedIn = signedIn
    }
    
    func signIn() {
        self.signedIn = true
    }
    
    func signOut(){
        self.signedIn = false
    }
}

struct LazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}
