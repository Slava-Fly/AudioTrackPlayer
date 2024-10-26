//
//  AudioPlayerViewController.swift
//  AudioTrackPlayer
//
//  Created by User on 23.10.2024.
//

import UIKit

class AudioPlayerViewController: UIViewController {
    private var viewModel: AudioPlayerViewModel
    private var isSliderBeingDragged = false
    
    private let titleLabel = UILabel()
    private let artistLabel = UILabel()
    private let progressSlider = UISlider()
    private let currentTimeLabel = UILabel()
    private let durationLabel = UILabel()
    private let playPauseButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    private let prevButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)
    
    private let playImage = UIImage(systemName: "play")
    private let pauseImage = UIImage(systemName: "pause")
    private let nextImage = UIImage(systemName: "forward.end")
    private let previousImage = UIImage(systemName: "backward.end")
    
    private var isPlaying = false {
        didSet {
            didTapPlayPause()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        
        updateTrackInfo(viewModel.currentTrack)
        
        viewModel.startTimer()
    }
    
    init(viewModel: AudioPlayerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func setupUI() {
        view.backgroundColor = .white
        
        playPauseButton.setImage(playImage, for: .normal)
        playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        
        closeButton.setTitle("X Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 18)
        artistLabel.textAlignment = .center
        artistLabel.font = .systemFont(ofSize: 14)
        currentTimeLabel.text = "00:00"
        currentTimeLabel.font = .systemFont(ofSize: 12)
        durationLabel.text = "00:00"
        durationLabel.font = .systemFont(ofSize: 12)
        playPauseButton.setImage(pauseImage, for: .normal)
        nextButton.setImage(nextImage, for: .normal)
        prevButton.setImage(previousImage, for: .normal)
        
        [titleLabel, artistLabel, progressSlider, currentTimeLabel, durationLabel, playPauseButton, nextButton, prevButton, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 450),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            artistLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            currentTimeLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 32),
            currentTimeLabel.leadingAnchor.constraint(equalTo: progressSlider.leadingAnchor),
            
            durationLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 32),
            durationLabel.trailingAnchor.constraint(equalTo: progressSlider.trailingAnchor),
            
            progressSlider.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 60),
            progressSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            progressSlider.bottomAnchor.constraint(equalTo: playPauseButton.topAnchor, constant: -40),
            
            playPauseButton.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 40),
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 50),
            playPauseButton.heightAnchor.constraint(equalToConstant: 50),
            
            prevButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            prevButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -20),
            
            nextButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            nextButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 20),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            
        ])
    }
    
    private func setupBindings() {
        viewModel.onTrackChange = { [weak self] track in
            self?.updateTrackInfo(track)
        }
        
        viewModel.onTimeUpdate = { [weak self] currentTime in
            self?.updateTime(currentTime)
        }
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(didTapPrev), for: .touchUpInside)
        
        progressSlider.setThumbImage(UIImage(), for: .normal)
        progressSlider.addTarget(self, action: #selector(progressSliderChanged(_:)), for: .valueChanged)
        progressSlider.addTarget(self, action: #selector(progressSliderTouchBegan(_:)), for: .touchDown)
        progressSlider.addTarget(self, action: #selector(progressSliderTouchEnded(_:)), for: [.touchUpInside, .touchUpOutside])
    }
    
    // Обновить данные о треке
    private func updateTrackInfo(_ track: Track) {
        titleLabel.text = track.title
        artistLabel.text = track.artist
        durationLabel.text = viewModel.formatTime(track.duration)
    }
    
    // Обновить время трека
    private func updateTime(_ currentTime: TimeInterval) {
        currentTimeLabel.text = viewModel.formatTime(currentTime)
        progressSlider.value =  viewModel.trackProgress() 
    }
    
    private func configure(with viewModel: AudioPlayerViewModel) {
        self.viewModel = viewModel
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func progressSliderTouchBegan(_ sender: UISlider) {
        isSliderBeingDragged = true
    }
    
    @objc private func progressSliderTouchEnded(_ sender: UISlider) {
        let newTime = TimeInterval(sender.value) * viewModel.duration
        viewModel.seek(to: newTime)
        isSliderBeingDragged = false
    }
    
    @objc private func progressSliderChanged(_ sender: UISlider) {
        let newTime = TimeInterval(sender.value) * viewModel.duration
        currentTimeLabel.text = viewModel.formatTime(newTime)
    }
    
    @objc private func didTapPlayPause() {
        viewModel.playPause()
        let buttonImage = isPlaying ? playImage : pauseImage
        playPauseButton.setImage(buttonImage, for: .normal)
    }
    
    @objc private func playPauseTapped() {
        isPlaying.toggle()
        viewModel.playPause()
    }
    
    @objc private func didTapNext() {
        viewModel.nextTrack()
    }
    
    @objc private func didTapPrev() {
        viewModel.previousTrack()
    }
}
