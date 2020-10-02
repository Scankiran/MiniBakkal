//
//  MainView.swift
//  MiniBakkal
//
//  Created by Said Çankıran on 2.10.2020.
//

import Foundation
import UIKit

class MainView:UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let btn = BadgedButtonItem(with: UIImage(named: "shoppingSolid"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn.setBadge(with: 2)
        btn.tapAction = {
            self.performSegue(withIdentifier: "toShoppingCart", sender: self)
        }
        self.navigationItem.rightBarButtonItem = btn
        
    }
    
}


extension MainView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func giveDelegateToCollectionView() {
        //Register Cell
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
