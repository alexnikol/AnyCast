// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public final class PodcastCell: UITableViewCell, Reusable {
    public private(set) var titleLabel = UILabel()
    public private(set) var thumbnailImageView = UIImageView()
    public private(set) var container = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    private func configureUI() {
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 4.0
        
        contentView.addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.0),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0)
        ])
        
        container.addSubview(thumbnailImageView)
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0.0),
            thumbnailImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0.0),
            thumbnailImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0.0),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 1)
        ])
        
        container.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8.0),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0.0),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0.0),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0.0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
