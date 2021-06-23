//
//  CLImageManager.swift
//  Clubus
//
//  Created by Christoph Erl on 15.03.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import Parse

class ERImageManager: NSObject {
    
    private static let shared = ERImageManager()
    
    private var map = [String: UIImage?]()
    
    override init() {
        super.init()
    }
    
    // MARK: - Static Methods
    
    class func image(from: PFFileObject, completion: @escaping ((UIImage?, Error?) -> ()), progress: ((Double) -> ())? = nil) {
        shared.image(from: from, completion: completion, progress: progress)
    }
    
    class func clear() {
        shared.clear()
    }
    
    // MARK: - Public Methods
    
    func image(from: PFFileObject, completion: @escaping ((UIImage?, Error?) -> ()), progress: ((Double) -> ())?) {
        if let image = map[from.name] {
            completion(image, nil)
            
        } else {
            from.getDataInBackground({ (data, error) in
                
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image, error)
                } else {
                    completion(nil, error)
                }
                
            }, progressBlock: { (p) in
                progress?(Double(p)/100)
            })
        }
    }
    
    func clear() {
        map.removeAll()
    }
    
    // MARK: - Private Helpers
    
    private func p_setImage(image: UIImage, key: String) {
        map[key] = image
    }
    
    private func p_removeImage(key: String) {
        map[key] = nil
    }

}
