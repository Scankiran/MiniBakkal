//
//  API.swift
//  MiniBakkal
//
//  Created by Said Çankıran on 3.10.2020.
//

import Foundation
import Kingfisher
import UIKit

class API {
    static let run = API()
    
    private let session = URLSession.shared
    private let cache = ImageCache.default
    
    func getProducts(handler:@escaping (_ result:[Product]?,_ error:Error?)->Void) {
        let url = URL(string: "https://desolate-shelf-18786.herokuapp.com/list")!

        let task = session.dataTask(with: url) { data, response, error in

            if error != nil || data == nil {
                print("Client error!")
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }

            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }

            do {
                let json = try JSONDecoder().decode([Product].self, from: data!)
                handler(json,nil)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
    
    
    
    
    func getImage(_ imageURL:String,_ productId:String, handler:@escaping(_ image:UIImage?,_ error:Error?)-> Void) {
        cache.memoryStorage.config.totalCostLimit = 1
        
        if !cache.isCached(forKey: productId) {
            let downloader = ImageDownloader.default
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            downloader.downloadImage(with: URL(string: imageURL)!, completionHandler:  { result in
                switch result {
                case .success(let value):
                    self.cache.storeToDisk(value.originalData, forKey: productId)
                    handler(value.image, nil)
                case .failure(let error):
                    handler(nil,error)
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            
        } else {
            cache.retrieveImage(forKey: productId) { result in
                switch result {
                    case .success(let value):
                        handler(value.image,nil)

                    case .failure(let error):
                        handler(nil,error)// The error happens
                    }
            }
        }
 
    }
    
    
    func sendProducts(handler:@escaping(_ result:Bool)->Void) {
        let data = createJson(shoppingCart: Session.run.cart)!

        let url = URL(string: "https://desolate-shelf-18786.herokuapp.com/checkout")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = data
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            do {
                _ = try JSONDecoder.init().decode(Order.self, from: data)
                handler(true)
            } catch {
                handler(false)
            }
        }

        task.resume()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    
    private func createJson(shoppingCart:[Product:Int]) -> Data?{
        let products = Array(shoppingCart.keys)
        let amounts = Array(shoppingCart.values)
        
        var informations:[[String:Any]] = []
        
        for index in 0..<products.count {
            let dict = ["id":products[index].id,"amount":amounts[index]] as [String : Any]
            informations.append(dict)
        }
        
        
        let body = try? JSONSerialization.data(withJSONObject: ["products":informations], options: [])
        return body
    }
    
    
}
