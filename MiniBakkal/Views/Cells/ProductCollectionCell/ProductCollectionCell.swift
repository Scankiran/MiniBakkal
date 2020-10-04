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
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    lazy var count = 0
    var amount = 0
    var product:Product?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setBorder(stackView)
        setBorder(valueLabel)
        
        decreaseValueButton.isHidden = true
        valueLabel.isHidden = true
        valueLabel.text = "0"
    
    }
    
    
    //MARK:Configure
    /**
     Configure Product cell with data.
     - Parameters:
        - data: Product
        - count:Product count on cart. (optional)
     
     Configure cell view with data property.
     Showed indicator when image fetched from server or disk.
     */
    func configure(_ data:Product,_ count:Int?) {
        
        let indicator = UIActivityIndicatorView.init(style: .gray)
        indicator.hidesWhenStopped = true
        indicator.frame = CGRect.init(origin: productImage.bounds.origin, size: CGSize.init(width: 46, height: 46))
        
        self.productImage.addSubview(indicator)
        indicator.startAnimating()
        
        API.run.getImage(data.imageUrl, data.id) { (image, err) in
            if let err = err {
                print(err.localizedDescription)
                indicator.stopAnimating()
                return
            }
            indicator.stopAnimating()
            self.productImage.image = image
            
        }
        
        priceLabel.text = "\(data.currency)\(data.price)"
        productNameLabel.text = data.name
        self.amount = data.stock
        product = data
        checkCount(count)

    }
    
    //MARK: Outlet Actions
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
            
            // If product on cart and product count is 1, remove from cart. But there are more product, remove just ones.
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




extension ProductCollectionCell {
    
    /**
     Check product count on cart.
     - Parameter count: Product count on cart.
     
     Product count optinal value because maybe product not add to cart. Function check first count value and do procces.
     If count not nil assign count to value label text and show on cell with buttons.
     */
    private func checkCount(_ count:Int?) {
        if let count = count {
            self.count = count
            valueLabel.text = "\(count)"
            decreaseValueButton.isHidden = false
            valueLabel.isHidden = false
        }
    }
    
    ///Set border to view content.
    private func setBorder(_ content:UIView) {
        content.layer.borderColor = UIColor.gray.cgColor
        content.layer.borderWidth = 1
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        decreaseValueButton.isHidden = true
        valueLabel.isHidden = true
        valueLabel.text = "0"
        count = 0
    }
}
