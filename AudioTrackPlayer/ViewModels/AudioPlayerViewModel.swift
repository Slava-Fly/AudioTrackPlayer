//
//  AudioPlayerViewModel.swift
//  AudioTrackPlayer
//
//  Created by User on 23.10.2024.
//

import Foundation
import AVFoundation

class AudioPlayerViewModel: NSObject, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?
    private var tracks: [Track]
    private var currentIndex: Int = 0
    
    var currentTrack: Track {
        return tracks[currentIndex]
    }
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    var currentTime: TimeInterval {
        return audioPlayer?.currentTime ?? 0
    }
    
    var duration: TimeInterval {
        return audioPlayer?.duration ?? 0
    }

    var onTrackChange: ((Track) -> Void)?
    var onTimeUpdate: ((TimeInterval) -> Void)?
    
    init(tracks: [Track], currentIndex: Int) {
        self.tracks = tracks
        self.currentIndex = currentIndex
        super.init()
        playTrack(at: currentIndex)
    }
    
    // Воспроизводим трек по индексу
    func playTrack(at index: Int) {
        let track = tracks[index]
        if let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3") {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            audioPlayer?.delegate = self
        } else {
            print("Файл трека не найден")
        }
    }
    
    // Пауза и воспроизведение
    func playPause() {
        guard let audioPlayer = audioPlayer else { return }
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
            startTimer()
        }
    }
    
    // Переход к следующему треку
    func nextTrack() {
        currentIndex = (currentIndex + 1) % tracks.count
        playTrack(at: currentIndex)
        audioPlayer?.play()
        onTrackChange?(currentTrack)
    }
    
    // Переход к предыдущему треку
    func previousTrack() {
        currentIndex = (currentIndex - 1 + tracks.count) % tracks.count
        playTrack(at: currentIndex)
        audioPlayer?.play()
        onTrackChange?(currentTrack)
    }
    
    // Прогресс воспроизведения аудиофайла 
    func trackProgress() -> Float {
        guard let player = audioPlayer else { return 0 }
        return Float(player.currentTime / player.duration)
    }
    
    // Форматирование времени из секунд в формат MM:SS
    func formatTime(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self, let audioPlayer = self.audioPlayer else {
                timer.invalidate()
                return
            }
            self.onTimeUpdate?(audioPlayer.currentTime)
        }
    }
    
    // Устанавливаем текущее время воспроизведения аудиофайла
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
        audioPlayer?.play()
    }
    
    // После окончания трека идёт переключение на следующий трек
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        nextTrack()
    }
}







