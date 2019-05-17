//
//  ClientTableViewController.swift
//  iOSPersonalTrainer
//
//  Created by AJMac on 5/7/19.
//  Copyright © 2019 AJMac. All rights reserved.
//

//Import Core Data
import UIKit
import CoreData


//View Controller conforms to UITableViewController
//Controller conforms to Client Delegate for CRUD operations
//Controller conforms to NSFetchedResults Controller to manage Core Data content with Fetching
class ClientTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, ClientDelegate {
    
    //Delegate protocol functions: new, modify and delete
    
    func newClient(name: String, age: Int16, initialWeight: Float, height: Float) {
        let clientEntity = Client(context: managedContext!)
        clientEntity.name = name
        clientEntity.age = age
        clientEntity.initialWeight = initialWeight
        clientEntity.height = height
        
        do {
            try managedContext!.save()
        }catch {
            managedContext!.reset()
            showAlert(title: "Error", message: "Failed to Add Client")
            print("Error Adding Client, \(error)")
        }
        
    }
    
    func modify(client: Client) {
        do {
            try client.validateForUpdate()
            try managedContext!.save()
        }catch{
            managedContext!.reset()
            showAlert(title: "Error", message: "Unable to Edit Client")
            print("Error saving Client, \(error)")
        }
    }
    
    func delete(client: Client) {
        do {
            managedContext!.delete(client)
            try managedContext!.save()
        }catch{
            managedContext!.reset()
            showAlert(title: "Error", message: "Unable to delete Client")
            
        }
    }
    
    //a content manager, a list of clients, and a fetcher
    var managedContext: NSManagedObjectContext?
    var clientObjects: [Client] = []
    var fetchResultsController:NSFetchedResultsController<Client>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fetch request for a client, and sort the results, validate than it can be opened
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        let clientFetch = NSFetchRequest<Client>(entityName: "Client")
        clientFetch.sortDescriptors = [sorter]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: clientFetch, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultsController!.delegate = self
        
        do {
            try fetchResultsController!.performFetch()
            clientObjects = fetchResultsController!.fetchedObjects!
        } catch {
            print ("Error fetching clients \(error)")
        }
        
    }
    //if the results changed, refetch data
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        clientObjects = controller.fetchedObjects as! [Client]
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientObjects.count
    }
    //I wanted to use a sorter and get the last date from weight records, but data types are conflicting so I used age to no return a nil value
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let client = clientObjects[indexPath.row]
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientTableCell")!
        cell.textLabel?.text = client.name
        cell.detailTextLabel?.text = "\(client.age)"
        return cell
    }
    
    //lots of segues for each client record
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addClient"?:
            let destination = segue.destination as! AddEditClientDetailViewController
            destination.clientDelegate = self
        
        case "clientEdit"?:
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let selectedRow = indexPath?.row
            let selectedClient = clientObjects[selectedRow!]
            let destination = segue.destination as! AddEditClientDetailViewController
            destination.client = selectedClient
            destination.clientDelegate = self
        
            
        default:
            print("Random Segue!")
        }
        
    }
    
}
