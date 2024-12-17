//
//  SettingsView.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import SwiftUI
import AVKit
import YouTubePlayerKit

struct SettingsView: View, SettingsViewProtocol {
    @ObservedObject
    private var presenter: SettingsPresenter
    @State private var showWebView = false
    @State private var isHelpCenter = false
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
            .sheet(isPresented: $isHelpCenter) {
                VideoListView(videos: mockCryptoVideos)
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
            
            switch (data.text) {
            case LocalizationKeys.Settings.logout:
                print("Logout triggered from settingsRow")
                break;
            case LocalizationKeys.Settings.privacyPolicy
                , LocalizationKeys.Settings.termsAndConditions:
                if let url = data.url, !url.isEmpty {
                    print("Opening URL: \(url)")
                    webViewURL = url
                    showWebView = true
                }
                break;
            case LocalizationKeys.Settings.helpCenter:
                isHelpCenter = true
                
                break;
            default:
                break;
            }
        }
    }
}

struct VideoListView: View {
    let videos: [Video]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedVideo: Video?
    
    var body: some View {
        VStack {
            CloseButtonView(title: "Crypto") {
                dismiss()
            }
            .padding()
            // Video List
            List {
                ForEach(videos) { video in
                    ZStack {
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
                        .frame(maxWidth: .infinity, maxHeight: 100)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 1)
                        )
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedVideo = video
                    }
                }
                .sheet(item: $selectedVideo) { video in
                    if video.url.contains("youtube.com") || video.url.contains("youtu.be") {
                        let youTubePlayer: YouTubePlayer = YouTubePlayer(source: .url(video.url))
                        YouTubePlayerView(youTubePlayer) { state in
                            switch state {
                            case .idle:
                                ProgressView()
                            case .ready:
                                EmptyView()
                            case .error(let error):
                                Text(verbatim: "YouTube player couldn't be loaded \n \(error)")
                            }
                        }
                    } else {
                        let player = AVPlayer(url: URL(string: video.url)!)
                        VideoPlayer(player: player)
                            .onAppear { player.play() }
                            .onDisappear { player.pause() }
                    }
                }
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

struct CloseButtonView: View {
    let title: String
    let onClose: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Text("Crypto")
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24) // Adjust size as needed
                    .foregroundColor(.red)
                    .accessibilityLabel("Close")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
