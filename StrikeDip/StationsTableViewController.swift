//
//  StationsTableViewController.swift
//  StrikeDip
//
//  Created by Aaron Lampshire on 12/7/17.
//  Copyright © 2017 Aaron Lampshire. All rights reserved.
//

//TODO - core data problems

import UIKit
import CoreData

class StationsTableViewController: UITableViewController {
    
    //weak var toDoItem:ToDoItem?//
    var stationItems:[StationItem] = []
    weak var projectItem:ProjectItem?
    let blue = UIColor(red: 4/255, green: 65/255, blue: 79/255, alpha: 1)
    let orange = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1)
    let white = UIColor(red: 255/255, green: 239/255, blue: 213/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDoListItem))
        let edit = self.editButtonItem
        self.editButtonItem.tintColor = orange
        add.tintColor = orange
        
        navigationItem.rightBarButtonItems = [add, edit]
        self.view.backgroundColor = white
        self.navigationController!.navigationBar.tintColor = white
        self.navigationController!.navigationBar.backItem?.backBarButtonItem?.tintColor = white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: white]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        stationItems = fetchItems()
        
        //don't yet need this
        //        if deleteOnComplete {
        //            var i = 0
        //            while i < projectItems.count {
        //                let item = projectItems[i]
        //                if item.isCompleted {
        //                    projectItems.remove(at: i)
        //                    moc.delete(item) //remove from entity
        //                    i -= 1
        //                }
        //                i += 1
        //            }
        //        }
        tableView.reloadData()
    }
    
    func fetchItems() -> [StationItem]{
        var fetchResults:[StationItem] = []
        
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest = NSFetchRequest<StationItem>(entityName: "StationItem")
        //let sortByDate:NSSortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        //        let predicate:NSPredicate = NSPredicate(format: "title == %@", argumentArray: [title!])
        //fetchRequest.sortDescriptors = [sortByDate]
        //        fetchRequest.predicate = predicate
        
        do {
            fetchResults = try moc.fetch(fetchRequest)
        } catch {
            print("Error")
        }
        print(fetchResults)
        
        return fetchResults
    }
    
    @IBAction func addToDoListItem() {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        
//        let desc:NSEntityDescription = NSEntityDescription.entity(forEntityName: "StationItem", in: moc)!
//        print(desc)
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "StationItem", into: moc)
        print(newItem)
        
        
        stationItems.insert(newItem as! StationItem, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section:0)], with: UITableViewRowAnimation.top)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stationItems.count
    }

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     let cell = tableView.dequeueReusableCell(withIdentifier: "stationItemCell", for: indexPath)
     
         // Configure the cell...
         if let stationItemCell = cell as? StationItemTableViewCell {
         let stationItem = stationItems[indexPath.row]
         stationItemCell.stationItem = stationItem
         stationItemCell.titleTextField.text = stationItem.title
     }
     
     return cell
     }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //DELETE function
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            stationItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        /*
         else if editingStyle == .Insert {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
         */
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "stationDetailSegue" {
            if let destinationVC = segue.destination as? StationDetailViewController{
                destinationVC.stationItem = stationItems[tableView.indexPathForSelectedRow!.row]
            }
        }
    }

}
