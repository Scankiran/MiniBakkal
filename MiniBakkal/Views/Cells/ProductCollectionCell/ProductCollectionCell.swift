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
    
    lazy var count = 0
    var amount = 0
    var product:Product?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setBorder(self.contentView)
        setBorder(increaseValueButton)
        setBorder(decreaseValueButton)
        decreaseValueButton.isHidden = true
        valueLabel.isHidden = true
        valueLabel.text = "0"
    
    }
    
    func configure(_ data:Product) {
        API.run.getImage(data.imageUrl, data.id) { (image, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            self.productImage.image = image
        }
        
        priceLabel.text = "\(data.currency)\(data.price)"
        productNameLabel.text = data.name
        self.amount = data.stock
        product = data
    }
    
    
    private func setBorder(_ content:UIView) {
        content.layer.borderColor = UIColor.gray.cgColor
        content.layer.borderWidth = 1
        
    }
    
    @IBAction private func increaseButtonAction(_ sender:UIButton) {
        if count < amount {
            decreaseValueButton.isHidden = false
            valueLabel.isHidden = false
            count += 1
            valueLabel.text = "\(count)"
            
            if Session.run.cart[product!] != nil {
                Session.run.cart[product!]! += 1
            } else {
                Session.run.cart[product!] = 1
            }
            MainView.updateBudge()
        }
        
       
        
    }
    
    @IBAction private func decreaseButtonAction(_ sender:UIButton) {
        if count > 0 {
            count -= 1
            valueLabel.text = "\(count)"
            
            if Session.run.cart[product!] != nil {
                if Session.run.cart[product!] == 1 {
                    Session.run.cart.removeValue(forKey: product!)
                } else {
                    Session.run.cart[product!]! -= 1
                }
            }
            MainView.updateBudge()
        }
        
        if count <= 0{
            decreaseValueButton.isHidden = true
            valueLabel.isHidden = true
        }
        
    }
    
    
}
