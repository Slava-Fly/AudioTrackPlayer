//
//  TracklistViewController.swift
//  AudioTrackPlayer
//
//  Created by User on 23.10.2024.
//

import UIKit

class TracklistViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = TracklistViewModel()
    private var currentTrackIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TrackCell.self, forCellReuseIdentifier: TrackCell.reuseIdentifier)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        viewModel.loadTracks()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TracklistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTracks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseIdentifier, for: indexPath) as? TrackCell else {
            return UITableViewCell()
        }
        let track = viewModel.selectedTrack(at: indexPath.row)
        cell.configure(with: track)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerViewModel = AudioPlayerViewModel(tracks: viewModel.tracks, currentIndex: indexPath.row)
        let audioPlayerVC = AudioPlayerViewController(viewModel: playerViewModel)
        audioPlayerVC.modalPresentationStyle = .pageSheet
        present(audioPlayerVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

