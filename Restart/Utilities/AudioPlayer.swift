//
//  AudioPlayer.swift
//  Restart
//
//  Created by Thitiphong Wancham on 23/2/2566 BE.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer!

func playSound(sound: String, type: String) {
    if let path = Bundle.main.url(forResource: sound, withExtension: type) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer?.play()
        } catch {
            print("Cannot play the sound file.")
        }
    }
}


