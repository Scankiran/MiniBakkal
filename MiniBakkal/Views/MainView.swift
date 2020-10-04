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
    static let btn = BadgedButtonItem(with: UIImage(named: "shoppingSolid"))
    var dataSet:[Product] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MainView.updateBudge()
        reloadData()
    }
    
    @objc func reloadData() {
        self.collectionView.reloadData()
    }
    
    
    //MARK UpdateBudge
    static func updateBudge() {
        self.btn.setBadge(with: Session.run.cart.values.reduce(0, +))
    }
    
}






//MARK: Collection View
extension MainView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSet.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionCell", for: indexPath) as! ProductCollectionCell
        
        let data = dataSet[indexPath.row]
        let count:Int? = Session.run.cart[data]
        
        cell.configure(dataSet[indexPath.row],count)
        
        return cell
    }
    
    
    func giveDelegateToCollectionView() {
        //Register Cell
        collectionView.register(UINib.init(nibName: "ProductCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
}



//MARK: View Function
extension MainView {
    private func setupView() {
        giveDelegateToCollectionView()
        
        //Assign action to Shopping Cart bar item
        MainView.btn.tapAction = {
            self.performSegue(withIdentifier: "toShoppingCart", sender: self)
        }
        
        self.navigationItem.rightBarButtonItem = MainView.btn
        
        API.run.getProducts { [self] (result, err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                self.dataSet = result!
                performSelector(onMainThread: #selector(reloadData), with: nil, waitUntilDone: false)
            }
        }
    }
}
