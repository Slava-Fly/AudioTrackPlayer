//
//  TrackCell.swift
//  AudioTrackPlayer
//
//  Created by User on 23.10.2024.
//

import Foundation
import UIKit

class TrackCell: UITableViewCell {
    static let reuseIdentifier = "TrackCell"
    
    private let viewModel = TracklistViewModel()
    
    private let artistLabel = UILabel()
    private let titleLabel = UILabel()
    private let durationLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
   
        contentView.addSubview(artistLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(durationLabel)
        
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: durationLabel.leadingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            artistLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            artistLabel.trailingAnchor.constraint(lessThanOrEqualTo: durationLabel.leadingAnchor, constant: -10),
            artistLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            artistLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),

            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            durationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            durationLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configure(with track: Track) {
        textLabel?.text = "\(track.artist) - \(track.title)"
        durationLabel.text = viewModel.formatTime(track.duration)
    }
}
