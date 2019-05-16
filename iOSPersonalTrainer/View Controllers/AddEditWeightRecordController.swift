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

class AddEditWeightRecordController: UIViewController, UIImagePickerControllerDelegate, ClientDelegate, WeightRecordDelegate, UINavigationControllerDelegate {
    
    //declare an instance of ImageStore and a Client
    var imageStore: ImageStore!
    var clientDelegate: ClientDelegate?
    var client: Client?
    
    let dateFormatter = { () -> DateFormatter in
        let df = DateFormatter()
        df.dateStyle = .long
        return df
    }()
    var delegate: WeightRecordDelegate?
    
    @IBOutlet var weightField: UITextField!
    @IBOutlet var recordDatePicker: UIDatePicker!
    @IBOutlet var bmiField: UITextField!
    @IBOutlet var imageField: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Weight Record"
        
       
    }
    //calculate the BMI based on the client's height and weight.
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
    //get the stored client from the ClientDelegate, then save new record
    @IBAction func saveButton(_ sender: Any) {
        
        let client = clientDelegate?.getClient!()
        
        let date = recordDatePicker.date
        
        guard let bmi = Float(bmiField.text!) else {
            showAlert(title: "Error", message: "Couldn't calculate BMI")
            return
        }
        
        
        guard let weight = Float(weightField.text!) else {
            showAlert(title: "Error", message: "Enter numerical data for height")
            return
        }
        // I don't think this is correct... how do I get the URL from the imagePicker?
        delegate?.newWeightRecord!(client: client!, weight: weight, date: date, bmi: bmi, photo: imageStore.imageURL)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //Get picked image from info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let urlForSaving = imageStore.imageURL
        //Store the image in the ImageStore
        imageStore.savePhoto(image: image, url:urlForSaving)
        
        //Put the image on the screen in the image view
        imageField.image = image
        
        //Tale the image picker off the screen
        //you must call this dismiss method
        dismiss(animated: true, completion: nil)
        
    }
    
}

