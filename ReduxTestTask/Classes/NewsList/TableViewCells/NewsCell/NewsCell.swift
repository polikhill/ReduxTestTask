//
//  NewsCell.swift
//  TestTask
//
//  Created by Polina on 8/18/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import UIKit

final class NewsCell: BaseTableViewCell {

    // MARK: - Private Properties

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var overlay: UIView!
    @IBOutlet private var backgroundImageView: UIImageView!

    static let identifier = "\(NewsCell.self)"
    static let designedHeight: CGFloat = 180
    static let designedWidtht: CGFloat = 335

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
    }

    // MARK: - Public Methods
    
    func configre(with article: Article) {
        backgroundImageView.setImage(.url(article.image), placeholder: HelperFunctions.randomImage())
        overlay.backgroundColor = .black(alpha: 0.5)

        titleLabel.setAttributedTitle(
            text: article.author, font: .subtitle(of: 13),
            color: .white, lineHeight: 20, letterSpacing: -0.13,
            alignment: .left
        )
        subtitleLabel.setAttributedTitle(
            text: article.title, font: .title(of: 22),
            color: .white, lineHeight: 26, letterSpacing: 0.28,
            alignment: .left
        )
        subtitleLabel.numberOfLines = 0
        
        guard let date = article.publishDate else {
            dateLabel.isHidden = true
            return
        }
        dateLabel.setAttributedTitle(
            text: TimeHelper.getString(fromDate: date, withFormat: .articleDate), font: .dateFont(of: 13),
            color: .white, lineHeight: 15, letterSpacing: -0.16,
            alignment: .right
        )
    }
}
