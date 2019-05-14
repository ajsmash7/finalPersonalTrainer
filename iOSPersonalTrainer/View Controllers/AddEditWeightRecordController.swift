//
//  AddEditWeightRecordController.swift
//  iOSPersonalTrainer
//
//  Created by AJMac on 5/7/19.
//  Copyright © 2019 AJMac. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddEditWeightRecordController: UIViewController, UIImagePickerControllerDelegate, WeightRecordDelegate, UINavigationControllerDelegate {
    
    var imageStore: ImageStore!
    
    let dateFormatter = { () -> DateFormatter in
        let df = DateFormatter()
        df.dateStyle = .long
        return df
    }()
    var delegate: WeightRecordDelegate?
    
    @IBOutlet var weightField: UITextField!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var bmiField: UITextField!
    @IBOutlet var imageField: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Weight Record"
       
    }
    
    func bmiCalculator(weight: Float, height: Float) -> Float {
        
        let bmi = ((weight/(height*height))*703)
        
        return bmi
    }
    
    @IBAction func takePicture(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        //If the device has a camera, take a picture; otherwise, pick from library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        
        //place image picker on the screen
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        
        guard let date = dateFormatter(DateFormatter.dateField.text!) else {
            showAlert(title: "Error", message: "Enter a date")
            return
        }
        guard let bmi = Float(bmiField.text!) else {
            showAlert(title: "Error", message: "Couldn't calculate BMI")
            return
        }
        
        guard let imageUrlString = (imageStore.imageURL) else {
            showAlert(title: "Error", message: "Enter numercial data for height")
            return
        }
        guard let weight = Float(weightField.text!) else {
            showAlert(title: "Error", message: "Enter numerical data for height")
            return
        delegate?.newWeightRecord(client: Client, weight: weight, date: date, bmi: bmi, photo: imageUrlString)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //Get picked image from info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //Store the image in the ImageStore
        imageStore.savePhoto(image)
        
        //Put the image on the screen in the image view
        imageView.image = image
        
        //Tale the image picker off the screen
        //you must call this dismiss method
        dismiss(animated: true, completion: nil)
        
    }
    
}

