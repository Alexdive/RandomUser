    //
    //  ImageDownloader.swift
    //  RandomUser
    //
    //  Created by Aleksei Permiakov on 29.04.2023.
    //

import Foundation
import Kingfisher
import UIKit


protocol ImageProtocol {}
extension UIImage: ImageProtocol {}

protocol ImageDownloader {
    func retrieveImage(stringUrl: String, completion: @escaping (_ image: ImageProtocol?) -> Void)
}

struct KingFisherImageDownloader: ImageDownloader {
    
    var manager = KingfisherManager.shared
    
    init() {}
    
    func retrieveImage(stringUrl: String, completion: @escaping (_ image: ImageProtocol?) -> Void) {
        guard let url = URL(string: stringUrl) else {
            completion(nil)
            return
        }
        
        let resource = ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: resource,
                                               options: nil,
                                               progressBlock: nil) { result in
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure:
                completion(nil)
            }
        }
    }
}
