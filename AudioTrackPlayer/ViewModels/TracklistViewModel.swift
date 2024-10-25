//
//  TracklistViewModel.swift
//  AudioTrackPlayer
//
//  Created by User on 23.10.2024.
//

import Foundation

class TracklistViewModel {
    private let tracklistStorage = TracklistStorage.shared
    
    var tracks: [Track] = []
    
    func numberOfTracks() -> Int {
        return tracks.count
    }
    
    func selectedTrack(at index: Int) -> Track {
        return tracks[index]
    }
    
    func loadTracks() {
        tracks = tracklistStorage.getTracklist()
    }
    
    // Форматирование времени из секунд в формат MM:SS
    func formatTime(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
