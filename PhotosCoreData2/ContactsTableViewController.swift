//
//  ContactsTableViewController.swift
//  CoreDataPhotos
//
//  Created by Liam Flaherty on 10/16/18.
//  Copyright © 2018 Liam Flaherty. All rights reserved.
//

import UIKit
import CoreData

class ContactsTableViewController: UITableViewController {

    var photoData:[PhotoEntity] = []
    
    @IBOutlet var ContactTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotos()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Alert(alertTitle: "Count of Table Data", String(photoData.count))
        return photoData.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let cell = cell as? ContactTableViewCell {
            let photo = photoData[indexPath.row]
            cell.contactImage.image = photo.image
            cell.contactName.text = photo.name
        }
        return cell
    }
    
    
    
    func fetchPhotos() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            photoData = try managedContext.fetch(fetchRequest)
        } catch {
            Alert(alertTitle: "Error", "Could not retrieve Photos")
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "push", let destination = segue.destination as? ContactViewController,
            let row = ContactTable.indexPathForSelectedRow?.row {
            destination.contactData = photoData[row]
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchPhotos()
        ContactTable.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteContact(at: indexPath)
        }
    }
    
    func deleteContact(at indexPath: IndexPath) {
        let contact = photoData[indexPath.row]
        
        guard let managedObjectContext = contact.managedObjectContext else{
            return
        }
            managedObjectContext.delete(contact)
            
            do {
                try managedObjectContext.save()
                self.photoData.remove(at: indexPath.row)
                ContactTable.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                ContactTable.reloadData()
            }
    }
    
    func Alert(alertTitle: String,_ alertMessage : String){
        let alertController = UIAlertController(title: alertTitle, message:
            alertMessage, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }



}
