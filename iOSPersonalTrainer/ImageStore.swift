//
//  ImageStore.swift
//  iOSPersonalTrainer
//
//  Created by AJMac on 5/14/19.
//  Copyright © 2019 AJMac. All rights reserved.
//

import UIKit

class ImageStore {
    
    
    let imageURL: URL = {
        let imageFilename = "weight_loss"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectory.first!
        return documentDirectory.appendingPathComponent(imageFilename)
    }()
    
    func savePhoto(image: UIImage) {
        if let data = UIImageJPEGRepresentation(image, 1) {
            try? data.write(to: imageURL, options: [.atomic])
        }
    }
    
    func getPhoto() -> UIImage? {
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path) else {
            
            return nil
        }
        return imageFromDisk
    }

    
    func deleteImage(image: UIImage) {
    
        let url = imageURL
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }
}

