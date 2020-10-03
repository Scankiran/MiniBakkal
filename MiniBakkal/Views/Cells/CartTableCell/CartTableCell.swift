//
//  CartTableCell.swift
//  MiniBakkal
//
//  Created by Said Çankıran on 2.10.2020.
//

import UIKit

class CartTableCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    lazy var count = 0
    var amount = 0
    var product:Product?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setBorder(valueLabel)
        setBorder(self.stackView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ data:Product, _ count:Int) {
        //Configure
        API.run.getImage(data.imageUrl, data.id) { (image, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            self.productImage.image = image!
        }
        
        productName.text = data.name
        productPrice.text = "\(data.currency)\(data.price)"
        
        valueLabel.text = "\(count)"
        
        self.amount = data.stock
        product = data
        self.count = count
    }
    
    
    private func setBorder(_ content:UIView) {
        content.layer.borderColor = UIColor.gray.cgColor
        content.layer.borderWidth = 1
        
    }
    
    @IBAction private func increaseButtonAction(_ sender:UIButton) {
        if count < amount {
            decreaseButton.isHidden = false
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
            decreaseButton.isHidden = true
            valueLabel.isHidden = true
        }

    }
    
    
    
}
