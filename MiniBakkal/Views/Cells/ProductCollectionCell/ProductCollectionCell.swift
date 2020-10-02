//
//  ProductCollectionCell.swift
//  MiniBakkal
//
//  Created by Said Çankıran on 2.10.2020.
//

import UIKit
import Kingfisher

class ProductCollectionCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var increaseValueButton: UIButton!
    @IBOutlet weak var decreaseValueButton: UIButton!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ data:Data) {
        
    }

}
