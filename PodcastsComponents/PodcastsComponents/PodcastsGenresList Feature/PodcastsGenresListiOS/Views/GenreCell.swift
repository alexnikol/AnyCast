// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public final class GenreCell: UICollectionViewCell, Reusable {
    private enum Defaults {
        static let defaultBackground: UIColor = .secondarySystemBackground
        static let highlightedBackground: UIColor = .tertiarySystemBackground
    }
    
    public private(set) lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .label
        view.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return view
    }()
    
    public private(set) lazy var tagView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    private func configureUI() {
        contentView.backgroundColor = Defaults.defaultBackground
        contentView.layer.cornerRadius = 4.0
        contentView.clipsToBounds = true
        
        contentView.addSubview(tagView)
        NSLayoutConstraint.activate([
            tagView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.0),
            tagView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0),
            tagView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0),
            tagView.widthAnchor.constraint(equalToConstant: 10.0)
        ])
        
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.0),
            nameLabel.leadingAnchor.constraint(equalTo: tagView.trailingAnchor, constant: 10.0),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0)
        ])
    }
    
    public func updateHighlighted(_ highlighted: Bool) {
        contentView.backgroundColor = highlighted ? Defaults.highlightedBackground : Defaults.defaultBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
