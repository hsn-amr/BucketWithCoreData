//
//  ViewController.swift
//  Bucket
//
//  Created by administrator on 12/12/2021.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var tasksItems = [TasksItems]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // this way to access buttons on nav bar
       // navigationItem.rightBarButtonItem = UIBarButtonItem(title: <#T##String?#>, style: <#T##UIBarButtonItem.Style#>, target: <#T##Any?#>, action: <#T##Selector?#>)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllItem()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasksItems[indexPath.row].taskText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            managedObjectContext.delete(tasksItems[indexPath.row])
            if saveChangesOfCotext() {
                tasksItems.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "Saving", sender: nil)
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "Saving", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let addViewController = segue.destination as! AddTableViewController
        addViewController.saveItemDeleagte = self
        if sender != nil {
            let index = sender as! Int
            let item = tasksItems[index]
            addViewController.index = index
            addViewController.item = item.taskText
        }
    }
   
    func fetchAllItem(){
        let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TasksItems")
        
        do {
            let result = try managedObjectContext.fetch(itemRequest)
            tasksItems = result as! [TasksItems]
            print("Fetched")
        } catch {
            print("\(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    func saveChangesOfCotext() -> Bool{
        var hasSaved = false
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Success")
                hasSaved = true
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        return hasSaved
    }
}


extension ViewController: SaveItemDelegate {
    func saveItem(item: String, at index: Int?) {
        if let at = index {
            tasksItems[at].taskText = item
            saveChangesOfCotext()
        }else{
            let task = NSEntityDescription.insertNewObject(forEntityName: "TasksItems", into: managedObjectContext) as! TasksItems
//            let task2 = TasksItems(context: managedObjectContext)
//            // 103 & 104 are same, they do same job
//            task2.taskText = item
            task.taskText = item
            if saveChangesOfCotext() {
                tasksItems.append(task)
            }
        }
        tableView.reloadData()
    }
    
    
}
