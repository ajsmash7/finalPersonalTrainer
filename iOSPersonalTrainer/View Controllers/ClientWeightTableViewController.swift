//
//  ClientWeightTableViewController.swift
//  iOSPersonalTrainer
//
//  Created by AJMac on 5/7/19.
//  Copyright © 2019 AJMac. All rights reserved.
//

import UIKit
import CoreData

class ClientWeightTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, WeightRecordDelegate {
    
    var imageStore = ImageStore()
    var managedContext: NSManagedObjectContext?
    var client: Client?
    var fetchedWeightRecordsController: NSFetchedResultsController<WeightRecord>?
    var weightRecords: [WeightRecord] = []
    
    let dateFormatter = { () -> DateFormatter in
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let client = client else {
            preconditionFailure("Client must be set")
        }
        
        navigationItem.title = "Weight Records for \(client.name!)"
        
        let clientPredicate = NSPredicate(format: "client == %@", client)
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        let weightRecordsFetch = NSFetchRequest<WeightRecord>(entityName: "WeightRecord")
        weightRecordsFetch.sortDescriptors = [sortDescriptor]
        weightRecordsFetch.predicate = clientPredicate
        
        fetchedWeightRecordsController = NSFetchedResultsController<WeightRecord>(fetchRequest: weightRecordsFetch, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedWeightRecordsController?.delegate = self
        
        do {
            try fetchedWeightRecordsController?.performFetch()
            weightRecords = fetchedWeightRecordsController!.fetchedObjects!
           
            
            }catch {
                print("error fetching weight records \(error)")
        }
       
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weightRecords.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell")!
        let weightRecord = weightRecords[indexPath.row]
        cell.textLabel?.text = "\(dateFormatter.string(from: weightRecord.date!))"
        cell.detailTextLabel?.text = "Weight: \(weightRecord.weight)"
        
        
        return cell
    }
    
    internal func newWeightRecord(client: Client, weight: Float, date: Date, bmi: Float, photo: URL) {
        let weightRecord = WeightRecord(context: managedContext!)
        weightRecord.client = client
        weightRecord.date = date
        weightRecord.bmi = bmi
        weightRecord.photo = photo
        
        do {
            try weightRecord.validateForInsert()
            try managedContext!.save()
        }catch {
            print("Error saving new weight record because \(error)")
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        weightRecords = controller.fetchedObjects as! [WeightRecord]
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addWeightRecord" {
            let addRecordController = segue.destination as! AddEditWeightRecordController
            addRecordController.delegate = self
            addRecordController.client = client!
        }
    }
    
    
}
    


