//
//  ImageStore.swift
//  iOSPersonalTrainer
//
//  Created by AJMac on 5/14/19.
//  Copyright © 2019 AJMac. All rights reserved.
//

import UIKit

class ImageStore {
    
    //assign a randomly generated file URL
    let imageURL: URL = {
        let imageFilename = UUID().uuidString
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectory.first!
        return documentDirectory.appendingPathComponent(imageFilename)
    }()
    
    //save the image to the file URL
    func savePhoto(image: UIImage, url:URL) {
        if let data = UIImageJPEGRepresentation(image, 1) {
            try? data.write(to: url, options: [.atomic])
        }
    }
    //get the photo from the URL
    func getPhoto(url:URL) -> UIImage? {
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            
            return nil
        }
        return imageFromDisk
    }
    
   
    
}

