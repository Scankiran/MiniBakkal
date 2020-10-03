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
    
    var dataSet:[Product] = []
    
    lazy var cart:[Product:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        giveDelegateToCollectionView()
        btn.setBadge(with: 2)
        btn.tapAction = {
            self.performSegue(withIdentifier: "toShoppingCart", sender: self)
        }
        
        self.navigationItem.rightBarButtonItem = btn
        
        API.run.getProducts { [self] (result, err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                self.dataSet = result!
                performSelector(onMainThread: #selector(asd), with: nil, waitUntilDone: false)
            }
        }
    }
    
    @objc func asd() {
        self.collectionView.reloadData()
    }
    
}


extension MainView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionCell", for: indexPath) as! ProductCollectionCell
        
        cell.configure(dataSet[indexPath.row])
        
        return cell
    }
    
    func giveDelegateToCollectionView() {
        //Register Cell
        collectionView.register(UINib.init(nibName: "ProductCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}
