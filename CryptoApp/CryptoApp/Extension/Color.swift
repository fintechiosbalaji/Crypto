//
//  Color.swift
//  CryptoApp
//
//  Created by Rockz on 14/11/24.
//

import SwiftUI

extension Color {
    static let primaryColor = Color("primaryColor")
    static let selectedTitleColor = Color("primaryColor")
    static let unselectedTitleColor = Color("pink")
    static let accentColor = Color.orange
}


extension View {
    
    func primaryBackground() -> some View {
        self.background(Color("primaryColor"))
    }
    
    func alphaPrimaryBackground() -> some View {
        self.background(Color("alpha-primary-color"))
    }
}
