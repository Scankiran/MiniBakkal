//
//  API.swift
//  MiniBakkal
//
//  Created by Said Çankıran on 3.10.2020.
//

import Foundation
import Kingfisher

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
    
    
    
    
}
