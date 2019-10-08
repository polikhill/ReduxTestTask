//
//  NewsCell.swift
//  TestTask
//
//  Created by Polina on 8/18/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import UIKit
import Kingfisher

final class NewsCell: UITableViewCell, NibInitializable, ReusableCell {

    // MARK: - Private Properties

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var overlay: UIView!
    @IBOutlet private var backgroundImageView: UIImageView!

    struct Props: Equatable {
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
        selectionStyle = .none
        backgroundImageView.layer.cornerRadius = 6
        backgroundImageView.contentMode = .scaleAspectFit
        overlay.layer.cornerRadius = 6
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImageView.image = nil
        backgroundImageView.kf.cancelDownloadTask()
    }
    
    // MARK: - Public Methods
    
    func render(props: Props) {
        backgroundImageView.kf.setImage(with: props.backgroundImageURL)
        titleLabel.text = props.title
        subtitleLabel.text = props.subtitle
        subtitleLabel.numberOfLines = 0
        dateLabel.text = props.date
    }
}
