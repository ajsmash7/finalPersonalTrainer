//
//  AddEditClientDetailViewController.swift
//  iOSPersonalTrainer
//
//  Created by AJMac on 5/7/19.
//  Copyright © 2019 AJMac. All rights reserved.
//


import UIKit
import CoreData

//So I made an app that does most of it's work on this view.
//This is where you view the clients current progress. The view uses delegates to pass information
//between the two entities. Because of this, It required that it conform to the protocol, but I made their CRUD constructors optional,
// so they can be useful when necessary, but don't have to muddy it up with redundant data

class AddEditClientDetailViewController: UIViewController, UITabBarControllerDelegate, NSFetchedResultsControllerDelegate, ClientDelegate, WeightRecordDelegate {
    
    // initialize data sources
    var imageStore: ImageStore!
    var managedContext: NSManagedObjectContext?
    var client: Client?
    var clientDelegate: ClientDelegate?
    var weightDelegate: WeightRecordDelegate?
    var fetchedWeightRecordsController: NSFetchedResultsController<WeightRecord>?
    var weightRecords: [WeightRecord] = []
    var firstRecord: WeightRecord?
    
    //create a date formatter
    let dateFormatter = { () -> DateFormatter in
        let df = DateFormatter()
        df.dateStyle = .long
        return df
    }()
    
    //wire up the outlets for the View Controller. If the client is currently existing, these fields are populated in viewDidLoad()
    @IBOutlet var navGuide: UINavigationItem!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var totalBMITextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var bmiTextField: UITextField!
    @IBOutlet var lastUpdatedOn: UITextField!
    @IBOutlet var currentPhoto: UIImageView!
    @IBOutlet var startDateField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if viewing the details of an existing client, load the data, call it a Profile.
        // the data from the segue is loaded here, the data from the current weight record is initialized and loaded in loadInitialData()
        // was cleaner that way
        if let c = client {
            navGuide.title = "Profile"
            nameTextField.text = c.name
            ageTextField.text = "\(c.age)"
            heightTextField.text = "\(c.height)"
            loadInitialData()
        }else{
            // else add new client
            navGuide.title = "Add Client"
        }
    }
    
        
    func loadInitialData() -> Void {
        //set who the client is
        guard let client = client else {
            preconditionFailure("Client must be set to edit current user")
        }

        //set the client as the Predicate parameter for the manager to determine which weight records to pull from Core Data
        let clientPredicate = NSPredicate(format: "client == %@", client)
        //set to sort the records by date
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        //apply the query parameters to the fetch
        let weightRecordsFetch = NSFetchRequest<WeightRecord>(entityName: "WeightRecord")
        weightRecordsFetch.sortDescriptors = [sortDescriptor]
        weightRecordsFetch.predicate = clientPredicate
        
        fetchedWeightRecordsController = NSFetchedResultsController<WeightRecord>(fetchRequest: weightRecordsFetch, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedWeightRecordsController?.delegate = self
        
        //fetch
        //if there is data, we want the most recent record to populate the Profile fields.
        do {
            try fetchedWeightRecordsController?.performFetch()
            weightRecords = fetchedWeightRecordsController!.fetchedObjects!
            if weightRecords.count > 0 {
                firstRecord =  weightRecords.first
                loadRecentData(record:firstRecord!)
                totalBMI(records: weightRecords)
            }else{
                showAlert(title: "Empty", message: "Client has not logged any progress")
            }
        }catch {
            print("error fetching weight records \(error)")
        }
        
    }

    
    func totalBMI(records:[WeightRecord]) -> Void {
        if records.count > 1 {
            let bmiStart = records.last!.bmi
            let bmiCurrent = records.first!.bmi
            let bmiTotal = (bmiStart-bmiCurrent)
            totalBMITextField.text! = "\(bmiTotal)"
        }else{
            showAlert(title: "Empty", message: "No Weight Records")
        }
        
    }
    
    func loadRecentData(record:WeightRecord) -> Void {
        weightTextField.text! = "\(record.weight)"
        bmiTextField.text! = "\(record.bmi)"
        lastUpdatedOn.text! = "\(dateFormatter.string(from: record.date!))"
        bmiTextField.text! = "\(record.bmi)"
        
       //currentPhoto
        currentPhoto.image = imageStore.getPhoto(url: record.photo!)
        
        
    }
    

        
    @IBAction func save(_ sender: Any) {
        guard let name = nameTextField.text else {
            showAlert(title: "Error", message: "Enter a name")
            return
        }
        guard let age = Int16(ageTextField.text!) else {
            showAlert(title: "Error", message: "Enter a numerical age")
            return
        }
        
        if age<0 || age>130 {
            showAlert(title: "Error", message: "Enter an age between 0 and 130")
            return
        }
        guard let height = Float(heightTextField.text!) else {
            showAlert(title: "Error", message: "Enter numercial data for height")
            return
        }
        guard let weight = Float(weightTextField.text!) else {
            showAlert(title: "Error", message: "Enter numerical data for height")
            return
        }
    
        
        
        if let existingClient = client {
            existingClient.age = age
            existingClient.name = name
            existingClient.height = height
            
        }else{
            clientDelegate?.newClient!(name: name, age: age, initialWeight: weight, height: height)
        }
    }
    
    @IBAction func deleteClient(_ sender: Any) -> Void {
        clientDelegate?.delete!(client: client!)
        navigationController!.popViewController(animated: true)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        clientDelegate?.setClient!(client: client!)
        
            
        }
    
}
    
    

