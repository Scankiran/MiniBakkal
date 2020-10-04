//
//  CustomBadge.swift
//  MiniBakkal
//
//  Created by Said Çankıran on 2.10.2020.
//

import Foundation
import UIKit

class BadgedButtonItem: UIBarButtonItem {

    public func setBadge(with value: Int) {
        self.badgeValue = value
    }
    
    @objc func buttonPressed() {
        if let action = tapAction {
            action()
        }
    }


    private var badgeValue: Int? {
        didSet {
            if let value = badgeValue,
                value > 0 {
                badgeLabel.isHidden = false
                badgeLabel.text = "\(value)"
            } else {
                badgeLabel.isHidden = true
            }
        }
    }

    var tapAction: (() -> Void)?

    private let badgeButton = UIButton()
    private let badgeLabel = UILabel()

    override init() {
        super.init()
        setup()
    }

    init(with image: UIImage?) {
        super.init()
        setup(image: image)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup(image: UIImage? = nil) {

        self.badgeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.badgeButton.adjustsImageWhenHighlighted = false
        self.badgeButton.setImage(image, for: .normal)
        self.badgeButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

        self.badgeLabel.frame = CGRect(x: 20, y: 0, width: 15, height: 15)
        self.badgeLabel.backgroundColor = UIColor.init(red: 194/255, green: 210/255, blue: 218/255, alpha: 1)
        self.badgeLabel.clipsToBounds = true
        self.badgeLabel.layer.cornerRadius = 7
        self.badgeLabel.layer.borderWidth = 1
        self.badgeLabel.layer.borderColor = UIColor.black.cgColor
        self.badgeLabel.textColor = UIColor.black
        self.badgeLabel.font = UIFont.systemFont(ofSize: 10)
        self.badgeLabel.textAlignment = .center
        self.badgeLabel.isHidden = true
        self.badgeLabel.minimumScaleFactor = 0.1
        self.badgeLabel.adjustsFontSizeToFitWidth = true
        
        self.badgeButton.addSubview(badgeLabel)
        self.customView = badgeButton
    }

    
}
