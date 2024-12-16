//
//  ProgressView.swift
//  CryptoApp
//
//  Created by Rockz on 10/12/24.
//

import SwiftUI

struct ProgressLoader: View {
    let progressMessage: String
    let additionalMessage: String?
    
    var body: some View {
        VStack {
            ProgressView(progressMessage.localizedKey)
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
                .padding()
            if let message = additionalMessage {
                Text(message.localizedKey)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .primaryBackground() 
    }
}

struct ProgressLoaderModifier: ViewModifier {
    let progressMessage: String
    let additionalMessage: String?
    
    func body(content: Content) -> some View {
        Group {
            if progressMessage.isEmpty && additionalMessage == nil {
                content
            } else {
                VStack {
                    ProgressView(progressMessage.localizedKey)
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding()
                    if let message = additionalMessage {
                        Text(message.localizedKey)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .primaryBackground() // Custom background
            }
        }
    }
}

extension View {
    func progressLoader(progressMessage: String, additionalMessage: String? = nil) -> some View {
        self.modifier(ProgressLoaderModifier(progressMessage: progressMessage, additionalMessage: additionalMessage))
    }
}
