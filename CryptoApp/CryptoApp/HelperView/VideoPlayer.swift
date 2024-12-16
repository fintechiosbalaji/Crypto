//
//  VideoPlayer.swift
//  CryptoApp
//
//  Created by Rockz on 02/12/24.
//


import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    let url: URL
    let autoPlay: Bool
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        controller.player = player
        
        if autoPlay {
            player.play()
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if let player = uiViewController.player, player.currentItem?.asset as? AVURLAsset != AVURLAsset(url: url) {
            uiViewController.player = AVPlayer(url: url)
            if autoPlay {
                uiViewController.player?.play()
            }
        }
    }
}


struct MyVideoPlayer: UIViewControllerRepresentable {
    var player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}


#Preview {
    VideoPlayerView(url: URL(string: "https://www.youtube.com/watch?v=VYWc9dFqROI")! , autoPlay: true)
}
