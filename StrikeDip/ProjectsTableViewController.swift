//
//  ProjectsTableViewController.swift
//  StrikeDip
//
//  Created by Aaron Lampshire on 12/6/17.
//  Copyright © 2017 Aaron Lampshire. All rights reserved.
//

import UIKit
import CoreData

class ProjectsTableViewController: UITableViewController {

    var projectItems:[ProjectItem] = []
    let blue = UIColor(red: 4/255, green: 65/255, blue: 79/255, alpha: 1)
    let orange = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1)
    let white = UIColor(red: 255/255, green: 239/255, blue: 213/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        self.navigationItem.rightBarButtonItem = self.editButtonItem
//        self.navigationItem.rightBarButtonItem = self.
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDoListItem))
        let edit = self.editButtonItem
        //change button colors
        self.editButtonItem.tintColor = orange
        add.tintColor = orange
        
        navigationItem.rightBarButtonItems = [add, edit]
        self.view.backgroundColor = white
        //self.navigationController!.navigationBar.barTintColor = UIColor(red: 28/255, green: 45/255, blue: 37/255, alpha: 1)
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: white]
        self.navigationController!.navigationBar.barTintColor = blue
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        
        projectItems = fetchItems()
        
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
    
    func fetchItems() -> [ProjectItem]{
        var fetchResults:[ProjectItem] = []
        
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest = NSFetchRequest<ProjectItem>(entityName: "ProjectItem")
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showStationView", sender: indexPath);
    }
    
    @IBAction func addToDoListItem() {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        
        let desc:NSEntityDescription = NSEntityDescription.entity(forEntityName: "ProjectItem", in: moc)!
        print(desc)
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "ProjectItem", into: moc)
        
        print("count ", projectItems.count)
        
        projectItems.insert(newItem as! ProjectItem, at: 0)
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
        return projectItems.count
    }

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectItemCell", for: indexPath)
     
        
        //set se
        
        
     // Configure the cell...
         if let projectItemCell = cell as? ProjectItemTableViewCell {
         let projectItem = projectItems[indexPath.row]
         projectItemCell.projectItem = projectItem
         //toDoItemCell.titleTextField.text = toDoItem.title
         projectItemCell.titleTextField.text = projectItem.title
//         if toDoItem.isCompleted {
//         toDoItemCell.accessoryType = UITableViewCellAccessoryType.checkmark
//         } else {
//         toDoItemCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
//         }
         }
         
         return cell
     }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view. DELETES the projects
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            projectItems.remove(at: indexPath.row)
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
        if segue.identifier == "showStationView" {
            if let destinationVC = segue.destination as? StationsTableViewController{
                destinationVC.projectItem = projectItems[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    

}
