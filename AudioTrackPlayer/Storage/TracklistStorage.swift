//
//  TracklistStorage.swift
//  AudioTrackPlayer
//
//  Created by User on 23.10.2024.
//

import Foundation

final class TracklistStorage {
    static let shared: TracklistStorage = {
        return TracklistStorage()
    }()
    
    private init() {}
    
    func getTracklist() -> [Track] {
        return [
            Track(title: "No Roots", artist: "Alice Merton", duration: 149.58, fileName: "NoRoots"),
            Track(title: "Warriors", artist: "Imagine Dragons", duration: 170.11, fileName: "Warriors"),
            Track(title: "Wandering Jew", artist: "Oxxxymiron", duration: 152.92, fileName: "WanderingJew"),
            Track(title: "Before winter", artist: "Oxxxymiron", duration: 152.30, fileName: "BeforeWinter"),
            Track(title: "Kaifograd", artist: "Slava KPSS", duration: 153.62, fileName: "KaifoGrad"),
            Track(title: "Nocnaia Travma", artist: "Zamai & Slava KPSS", duration: 238.26, fileName: "NocnaiaTravma"),
            Track(title: "American boy", artist: "Kombination", duration: 270.24, fileName: "American-boy"),
            Track(title: "Aborigen", artist: "Zamai", duration: 104.62, fileName: "Aborigen")
        ]
    }
}
