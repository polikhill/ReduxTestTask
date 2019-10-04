//
//  NewsCell.swift
//  TestTask
//
//  Created by Polina on 8/18/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import UIKit
import Kingfisher
import IGListKit

final class NewsCell: BaseCollectionViewCell, NibInitializable, ReusableCell {
    
    // MARK: - Private Properties
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var backgroundImageView: UIImageView!
    
    struct Props: Equatable, Diffable {
        
        var diffIdentifier: String {
            return (title + date)
        }
        
        let title: String
        let subtitle: String
        let date: String
        let backgroundImageURL: URL?
    }
    
    static let identifier = "\(NewsCell.self)"
    static let designedHeight: CGFloat = 180
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImageView.layer.cornerRadius = 6
        backgroundImageView.contentMode = .scaleAspectFit
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImageView.image = nil
    }
    
    private func render(props: Props) {
        backgroundImageView.kf.setImage(with: props.backgroundImageURL)
        titleLabel.text = props.title
        subtitleLabel.text = props.subtitle
        subtitleLabel.numberOfLines = 0
        dateLabel.text = props.date
    }
}

extension NewsCell: ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let props = viewModel as? DiffableBox<NewsCell.Props> else { return }
        self.render(props: props.value)
    }
}
