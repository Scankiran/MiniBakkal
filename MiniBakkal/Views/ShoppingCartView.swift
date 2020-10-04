//
//  ShoppingCartView.swift
//  MiniBakkal
//
//  Created by Said Çankıran on 2.10.2020.
//

import UIKit
import JGProgressHUD

class ShoppingCartView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    let hud = JGProgressHUD.init(style: .dark)
    var totalPrice:Double = 0 {
        didSet {
            totalPriceLabel.text = "₺\(totalPrice)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func removeProducts() {
        //Remove product from shopping cart if not empty
        if !Session.run.cart.isEmpty {
            createAlert()
        }
        
    }
    
    
    @objc func back() {
        //Remove product from shopping cart.
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func confirmAndSendCart(_ sender: Any) {
        if !Session.run.cart.isEmpty {
            hud.textLabel.text = "Gönderiliyor"
            hud.show(in: self.view, animated: true)
            
            API.run.sendProducts { [self] (result) in
                if result {
                    Session.run.cart.removeAll()
                    performSelector(onMainThread: #selector(reloadData), with: nil, waitUntilDone: false)
                    performSelector(onMainThread: #selector(updatePrice), with: nil, waitUntilDone: false)
                    performSelector(onMainThread: #selector(showSuccesHud), with: nil, waitUntilDone: false)
                    
                    //Remove product selected values after ordered.
                    performSelector(onMainThread: #selector(MainView.reloadData), with: nil, waitUntilDone: false)
                    
                } else {
                    performSelector(onMainThread: #selector(showFailHud), with: nil, waitUntilDone: false)
                }
            }
            
        } else {
            hud.textLabel.text = "Sepetiniz Boş!"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view, animated: true)
            hud.dismiss(afterDelay: 2, animated: true)
        }
        
    }
 
}




//MARK: TableView
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
    
    //Show total price on view.
    @objc func updatePrice() {
        self.totalPrice = Session.run.totalPrice
    }
    
    
}



//MARK: View Functions
extension ShoppingCartView {
    
    ///Setup ShoppingCart View fetaures.
    private func setupView() {
        let deleteButton = UIBarButtonItem.init(title: "Sil", style: .plain, target: self, action: #selector(removeProducts))
        let closeButton = UIBarButtonItem.init(title: "Kapat", style: .plain, target: self, action: #selector(back))
        deleteButton.tintColor = UIColor.red

        self.navigationItem.leftBarButtonItem = deleteButton
        self.navigationItem.rightBarButtonItem = closeButton
        totalPrice = Session.run.totalPrice
        // Do any additional setup after loading the view.
        giveDelegateToTableView()
    }
    
    
    ///Create custom alert and show on view.
    private func createAlert() {
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
    
    @objc private func reloadData() {
        tableView.reloadData()
    }
    
    @objc private func showSuccesHud() {
        hud.textLabel.text = "Ürünler gönderildi."
        hud.indicatorView = JGProgressHUDSuccessIndicatorView.init()
        hud.show(in: self.view, animated: true)
        hud.dismiss(afterDelay: 2, animated: true)
    }
    
    @objc private func showFailHud() {
        hud.textLabel.text = "Bir hata oluştu. Lütfen daha sonra tekrar deneyiniz."
        hud.indicatorView = JGProgressHUDErrorIndicatorView.init()
        hud.show(in: self.view, animated: true)
        hud.dismiss(afterDelay: 2, animated: true)
    }
    
}
