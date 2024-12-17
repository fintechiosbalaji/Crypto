//
//  SettingsView.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI
import AVKit

extension Notification.Name {
    static let themeChanged = Notification.Name("themeChanged")
    static let languageChanged = Notification.Name("languageChanged")
}

struct SettingsView: View, SettingsViewProtocol {
    @ObservedObject
    private var presenter: SettingsPresenter
    @State private var showWebView = false
    @State private var webViewURL: String?
    
    @AppStorage("theme")
    var isDarkMode: Bool = true
    @AppStorage("language")
    private var selectedLanguage = LocalizationService.shared.language
    @State private var selectedMode = 0
    
    init(presenter: SettingsPresenter) {
        self.presenter = presenter
    }
    
    var body: some View {
        NavigationStack() {
            List {
                ForEach(presenter.settingsSections) { section in
                    Section(header: Text(section.title.localized(selectedLanguage))){
                        ForEach(section.items) { item in
                            settingsRow(data: item)
                        }
                    }
                    .listRowBackground(Color("alpha-primary-color"))
                }
                // Language Picker Section
                Section(header: Text("Language Settings".localized(selectedLanguage))) {
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(Language.allCases, id: \.self) { language in Text(language.displayName).tag(language)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedLanguage) { _,  newValue in
                        LocalizationService.shared.language = newValue
                        print("Language changed to: \(newValue.displayName)")
                    }
                }
                // Theme Picker Section
                Section(header: Text("Theme Settings".localized(selectedLanguage))) {
                    Picker("Color", selection: $isDarkMode) {
                        Text("Light".localized(selectedLanguage)).tag(false)
                        Text("Dark".localized(selectedLanguage)).tag(true)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: isDarkMode) { _,  newValue in
                        print("Theme changed to: \(newValue ? "Dark" : "Light")")
                    }
                }
            }
            .padding(.bottom, 20)
            .listStyle(.insetGrouped)
            .primaryBackground()
            .scrollContentBackground(.hidden)
            .onAppear {
                selectedLanguage = LocalizationService.shared.language
                presenter.loadSettings()
            }
            .sheet(isPresented: $showWebView) {
                if let validURL = URL(string: webViewURL ?? "https://crypto.com") {
                    LoadingWebView(showWebView: $showWebView, url: validURL)
                } else {
                    Text("Invalid URL")
                        .foregroundColor(.red)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .modifier(DarkModeViewModifier())
    }
    
    private func settingsRow(data: SettingsItem) -> some View {
        HStack {
            Image(data.image ?? "gear")
                .resizable()
                .foregroundColor(isDarkMode ? .orange : .gray)
                .frame(width: 20, height: 20)
                .padding(.leading, 5)
            Text(data.text.localized(selectedLanguage))
                .font(.callout)
                .foregroundColor(isDarkMode ? .white : .gray)
                .padding(.leading, 5)
            Spacer()
            Image("right-arrow")
        }
        .foregroundColor(isDarkMode ? .orange : .gray)
        .onTapGesture {
            print("Tapped on: \(data.text)")
            if data.text == "Logout" {
                print("Logout triggered from settingsRow")
            } else if let url = data.url, !url.isEmpty {
                print("Opening URL: \(url)")
                webViewURL = url
                showWebView = true
            }
        }
    }
}

struct LoadingWebView: View {
    @Binding var showWebView: Bool
    @State private var isLoading = true
    @State private var error: Error? = nil
    let url: URL?
    
    var body: some View {
        ZStack {
            if let error = error {
                Text(error.localizedDescription)
                    .foregroundColor(.pink)
            } else if let url = url {
                WebView(url: url,isLoading: $isLoading)
                    .edgesIgnoringSafeArea(.all)
                if isLoading {
                    ProgressView()
                }
            } else {
                Text("Sorry, we could not load this url.")
            }
        }
    }
}

struct VideoListView: View {
    let videos: [Video]
    
    var body: some View {
        List(videos) { video in
            NavigationLink(destination: VideoPlayerView(url: URL(string: video.url)!, autoPlay: true)) {
                HStack {
                    Image(systemName: "video")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding()
                    VStack(alignment: .leading) {
                        Text(video.title)
                            .font(.headline)
                        Text(video.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle("Help Videos")
    }
}

struct VideoListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView(videos: [
            Video(title: "Understanding Crypto Basics", url: "https://example.com/video1", description: "Learn the basics of cryptocurrency."),
            Video(title: "How to Secure Your Wallet", url: "https://example.com/video2", description: "Tips for securing your crypto wallet."),
        ])
    }
}
