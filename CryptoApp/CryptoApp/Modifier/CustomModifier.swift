//
//  CustomModifier.swift
//  CryptoApp
//
//  Created by Rockz on 19/11/24.
//

import Foundation
import SwiftUI

public extension UserDefaults {
    static let appGroup = UserDefaults(suiteName: "group.com.CryptApp")!
}

public struct DarkModeViewModifier: ViewModifier {
    @AppStorage("theme") var isDarkMode: Bool = true
    
    public func body(content: Content) -> some View {
        content
            .environment(\.colorScheme, isDarkMode ? .dark : .light)
            .preferredColorScheme(isDarkMode ? .dark : .light) // tint on status bar
    }
}

struct CustomButtonStyle: ViewModifier {
    var bgColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(bgColor) // Apply background first
            .cornerRadius(20)    // Apply corner radius after the background
            .padding(24)
    }
}

struct GradientBackground: ViewModifier {
    var colors: [Color]
    
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct CustomTabItemModifier: ViewModifier {
    let imageName: String
    let title: String
    let isActive: Bool
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("language")
    private var language = LocalizationService.shared.language
   
    func body(content: Content) -> some View {
        VStack(spacing: 10) {
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(colorScheme == .dark ? (isActive ? .orange : .gray) : (isActive ? .black : .gray))
                .frame(width: 20, height: 20)
            Text(title.localized(language))
                .font(.system(size: 10))
               
                .foregroundColor(colorScheme == .dark ? (isActive ? .orange : .gray) : (isActive ? .black : .gray))
                .lineLimit(nil)  // Allows word wrap
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ActionButton: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title.localizedKey)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(10)
        }
    }
}

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding(.bottom, 8)
    }
}

struct ValueModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let font: Font
    let padding: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8))
            //.foregroundColor(.white.opacity(0.8))
            .padding(.bottom, padding)
    }
}

struct ListTopSpacingModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
        .listStyle(.plain)
        .environment(\.defaultMinListHeaderHeight, 0)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.clear)
    }
}

struct AlertModifier: ViewModifier {
    var title: String
    var message: String
    var primaryButtonText: String
    var primaryAction: () -> Void
    var secondaryButtonText: String
    var secondaryAction: () -> Void

    func body(content: Content) -> some View {
        content
            .alert(isPresented: .constant(true)) {
                Alert(
                    title: Text(title),
                    message: Text(message),
                    primaryButton: .destructive(Text(primaryButtonText), action: primaryAction),
                    secondaryButton: .cancel(secondaryAction)
                )
            }
    }
}

extension View {
    func confirmationAlert(title: String, message: String, primaryButtonText: String, primaryAction: @escaping () -> Void, secondaryButtonText: String, secondaryAction: @escaping () -> Void) -> some View {
        self.modifier(AlertModifier(title: title, message: message, primaryButtonText: primaryButtonText, primaryAction: primaryAction, secondaryButtonText: secondaryButtonText, secondaryAction: secondaryAction))
    }
    
    func applyListTopSpacingModifier() -> some View {
        self.modifier(ListTopSpacingModifier())
    }
    
    func valueStyle(font: Font = .title2, padding: CGFloat = 16) -> some View {
        self.modifier(ValueModifier(font: font, padding: padding))
    }
  
    func gradientBackground(colors: [Color]) -> some View {
        self.modifier(GradientBackground(colors: colors))
    }
    
    func applyCustomButtonStyle(bgColor: Color) -> some View {
           self.modifier(CustomButtonStyle(bgColor: bgColor))
       }
    
    func customTabItem(imageName: String, title: String, isActive: Bool) -> some View {
        self.modifier(CustomTabItemModifier(imageName: imageName, title: title, isActive: isActive))
    }
}
