//
//  ArticleView.swift
//  ReduxTestTask
//
//  Created by Polina Hill on 10/3/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit
import RxSwift

final class ArticleView: UIView, NibInitializable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    struct Props: Equatable {
        let title: String
        let subtitle: String
        let date: String
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        subtitleLabel.numberOfLines = 0
    }
    
    // MARK: - Public Methods
    
    func render(props: Props) {
        titleLabel.text = props.title
        subtitleLabel.text = props.subtitle
        dateLabel.text = props.date
    }
}
