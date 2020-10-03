//
//  ShoppingCartView.swift
//  MiniBakkal
//
//  Created by Said Çankıran on 2.10.2020.
//

import UIKit

class ShoppingCartView: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var totalPrice:Double = 0 {
        didSet {
            totalPriceLabel.text = "₺\(totalPrice)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let deleteButton = UIBarButtonItem.init(title: "Sil", style: .plain, target: self, action: #selector(removeProducts))
        let closeButton = UIBarButtonItem.init(title: "Kapat", style: .plain, target: self, action: #selector(back))
        deleteButton.tintColor = UIColor.red

        self.navigationItem.leftBarButtonItem = deleteButton
        self.navigationItem.rightBarButtonItem = closeButton
        totalPrice = Session.run.totalPrice
        // Do any additional setup after loading the view.
        giveDelegateToTableView()
    }
    
    @objc func removeProducts() {
        //Remove product from shopping cart.
        if !Session.run.cart.isEmpty {
            let alert = UIAlertController.init(title: "Emin Misiniz?", message: "Sepetinizde eklediğiniz ürünler silinecektir. Emin misiniz?", preferredStyle: .alert)
            
            let delete = UIAlertAction.init(title: "Sil", style: .destructive) { (action) in
                Session.run.cart.removeAll()
                self.tableView.reloadData()
                self.totalPrice = 0
            }
            let cancel = UIAlertAction.init(title: "Vazgeç", style: .cancel, handler: nil)
            
            alert.addAction(delete)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func back() {
        //Remove product from shopping cart.
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmAndSendCart(_ sender: Any) {
        API.run.sendProducts { [self] (result) in
            if result {
                Session.run.cart.removeAll()
                performSelector(onMainThread: #selector(reloadData), with: nil, waitUntilDone: false)
                performSelector(onMainThread: #selector(updatePrice), with: nil, waitUntilDone: false)
            } else {
                //Show fail
            }
        }
    }
    
    @objc func reloadData() {
        tableView.reloadData()
    }
}


extension ShoppingCartView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Session.run.cart.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableCell") as! CartTableCell
        
        let data = Array(Session.run.cart.keys)[indexPath.row]
        let count = Session.run.cart[data]!
        
        cell.configure(data, count)
        
        cell.decreaseButton.addTarget(self, action: #selector(updatePrice), for: .touchUpInside)
        cell.increaseButton.addTarget(self, action: #selector(updatePrice), for: .touchUpInside)
        return cell
    }
    
    
    func giveDelegateToTableView() {
        tableView.register(UINib.init(nibName: "CartTableCell", bundle: nil), forCellReuseIdentifier: "CartTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 107
    }
    
    @objc func updatePrice() {
        self.totalPrice = Session.run.totalPrice
    }
    
}
