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
import Combine

struct SettingsView: View, SettingsViewProtocol {
    @ObservedObject
    private var presenter: SettingsPresenter
    @State private var showWebView = false
    @State private var isHelpCenter = false
    @State private var webViewURL: String?
    @State private var selectedMode = 0
    @State private var searchText = ""
    
    @AppStorage("theme")
    var isDarkMode: Bool = true
    @AppStorage("language")
    private var selectedLanguage = LocalizationService.shared.language
    
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
                self.languageSettingsection
                // Theme Picker Section
                self.themeSettingsSection
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
    
    private var themeSettingsSection: some View {
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
    
    private var languageSettingsection: some View {
        Section(header: Text("Language Settings".localized(selectedLanguage))) {
            Picker("Language", selection: $selectedLanguage) {
                ForEach(Language.allCases, id: \.self) { language in
                    Text(language.displayName)
                        .tag(language)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedLanguage) { _,  newValue in
                LocalizationService.shared.language = newValue
                print("Language changed to: \(newValue.displayName)")
            }
        }
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
            self.handleSettinsTap(data: data)
        }
    }
    
    private func handleSettinsTap(data: SettingsItem) {
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

struct VideoListView: View {
    let videos: [Video]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedVideo: Video?
    @State private var searchText = ""
    
    private var filteredVideos: [Video] {
        if searchText.isEmpty {
            return videos
        } else {
            return videos.filter { $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack {
            CloseButtonView(title: "Crypto") {
                dismiss()
            }
            SearchBar(text: $searchText)
            List {
                ForEach(filteredVideos) { video in
                    VideoCellView(video: video)
                        .frame(maxWidth: .infinity)
                        .listRowInsets(EdgeInsets())
                        .onTapGesture {
                            selectedVideo = video
                        }
                }
            }
            .listStyle(.plain)
            .padding(16)
            .sheet(item: $selectedVideo) { video in
                VideoDetailView(video: video)
            }
        }
    }
}

struct VideoDetailView: View {
    let video: Video
    var body: some View {
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

struct VideoCellView: View {
    let video: Video?
    var body: some View {
        HStack {
            Image(systemName: "video")
                .resizable()
                .frame(width: 40, height: 40)
                .padding()
            VStack(alignment: .leading) {
                Text(video?.title ?? "")
                    .font(.headline)
                    .foregroundColor(.white)
                Text(video?.description ?? "")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Ensure the text takes the full width }
        }
        .frame(height: 110)
        .padding(5)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.vertical, 5)
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

struct SearchBar: View {
    @Binding var text: String
    @State private var debounceTimer: AnyCancellable?
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onChange(of: text) { _ , newText in
                    debounceTimer?.cancel()
                    debounceTimer = Just(newText)
                        .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                        .sink { value in
                            // Handle the debounced search text update here
                        }
                }
        }
    }
}
