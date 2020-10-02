//
//  ShoppingCartView.swift
//  MiniBakkal
//
//  Created by Said Çankıran on 2.10.2020.
//

import UIKit

class ShoppingCartView: UIViewController {
    let deleteButton = UIBarButtonItem.init(title: "Sil", style: .plain, target: self, action: #selector(removeProducts))
    let closeButton = UIBarButtonItem.init(title: "Kapat", style: .plain, target: self, action: #selector(back))
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.tintColor = UIColor.red
        
        self.navigationItem.leftBarButtonItem = deleteButton
        self.navigationItem.rightBarButtonItem = closeButton
        // Do any additional setup after loading the view.
    }
    @objc func removeProducts() {
        //Remove product from shopping cart.
        print("remove")
    }
    
    @objc func back() {
        //Remove product from shopping cart.
        print("back")
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func confirmAndSendCart(_ sender: Any) {
    }
    
}


extension ShoppingCartView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func giveDelegateToTableView() {
        //Register Cell
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
}
