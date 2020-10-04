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
    
    //MARK: Variables
    private let session = URLSession.shared
    private let cache = ImageCache.default
    
    //MARK: Get Products
    /**
     Get product from server
     - Parameters:
        - handler: Return result or error
        - result: Optional Product array
        - error: Error
     
     Send get request to server with URLSession and check data. If everthing ok, send result data to handler. If not, send error to handler.
     */
    func getProducts(handler:@escaping (_ result:[Product]?,_ error:Error?)->Void) {
        let url = URL(string: "https://desolate-shelf-18786.herokuapp.com/list")!

        let task = session.dataTask(with: url) { data, response, error in

            //If return nothing
            if error != nil || data == nil {
                print("Client error!")
                return
            }

            //If there is a problem on Server
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }

            //If there is a problem Content type
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }

            //Do decoder procces if everthing okey
            do {
                let json = try JSONDecoder().decode([Product].self, from: data!)
                handler(json,nil)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
    
    
    //MARK: Get Images

    /**
    Get image from server and cache
     - Parameters:
        - imageURL: Product image url
        - productId: Product id for cache key
        -  handler: Return image or error.
     
     Get image from server with Product image url and check image cached or not. If not cached, store to disk with product id and return image. If cached, just return image.
     If there is no image or no response from server, return error with handler.
     */
    func getImage(_ imageURL:String,_ productId:String, handler:@escaping(_ image:UIImage?,_ error:Error?)-> Void) {
        cache.memoryStorage.config.totalCostLimit = 1
        
        if !cache.isCached(forKey: productId) {
            let downloader = ImageDownloader.default
            
            //Show network activity indicator
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            //Download image
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
            //Get image from cache.
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
    
    
    //MARK: Send Product

    /**
     Send product to server to save user shopping cart.
     
     - Parameters:
        - handler: Return bool as succes or not
        - result: Show procces status.
     */
    func sendProducts(handler:@escaping(_ result:Bool)->Void) {
        let data = createJson(shoppingCart: Session.run.cart)!

        let url = URL(string: "https://desolate-shelf-18786.herokuapp.com/checkout")!
        var request = URLRequest(url: url)
        
        //Add data to body and set request method.
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = data
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //Send data to server.
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            //Check response to acceptivity type. If not return bad result.
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
    
    
    //MARK: Create Json

    /**
     Create json data with shopping cart product
     - Parameters:
        - shoppingCart: Shopping cart
     
     This method create json data with shopping cart product id and product count to save user products on server.
     Convert data to acceptivity type.
     */
    private func createJson(shoppingCart:[Product:Int]) -> Data?{
        let products = Array(shoppingCart.keys)
        let amounts = Array(shoppingCart.values)
        
        var informations:[[String:Any]] = []
        
        for index in 0..<products.count {
            let dict = ["id":products[index].id,"amount":amounts[index]] as [String : Any]
            informations.append(dict)
        }
        
        //Convert to json
        let body = try? JSONSerialization.data(withJSONObject: ["products":informations], options: [])
        return body
    }
    
    
}
