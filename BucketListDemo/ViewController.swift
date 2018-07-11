//
//  ViewController.swift
//  BucketListDemo
//
//  Created by Ashwin Mahesh on 7/10/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var tableData:[BucketListItem]=[BucketListItem]()
    @IBOutlet weak var tableView: UITableView!
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    @IBAction func addPushed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddSegue", sender: sender)
    }
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource=self
        tableView.delegate=self
        tableView.rowHeight=70
        fetchAllItems()
    }
    
    func fetchAllItems(){
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BucketListItem")
        let request:NSFetchRequest<BucketListItem>=BucketListItem.fetchRequest()
        do{
            let result = try managedObjectContext.fetch(request)
            tableData = result
            print("Fetched all items")
            for item in tableData{
                print(item.text)
            }
        }
        catch{
            print("\(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func unwindToMainVC(segue: UIStoryboardSegue){
        let source = segue.source as! AddItemVC
        if let indexPath = source.indexPath{
//            Editing Data
            let text = source.textField.text!
//            ATTEMPTING EDIT FROM HERE
            tableData[indexPath.row].text=text
//            if managedObjectContext.hasChanges{
//                do{
//                    try managedObjectontext.save()
//                    print("Successfully edited")
//                }
//                catch{
//                    print("\(error)")
//                }
//            }
            saveContext()
//            END OF EDIT
            
            
//            tableData[indexPath.row]=text
//            tableView.reloadData()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        else{
//            Adding New Data
            let text = source.textField.text!
            let newObject=NSEntityDescription.insertNewObject(forEntityName: "BucketListItem", into: managedObjectContext) as! BucketListItem
            newObject.text=text
//            if managedObjectContext.hasChanges{
//                do{
//                    try managedObjectContext.save()
//                    print("Successfully added object")
//                }
//                catch{
//                    print("\(error)")
//                }
//            }
            saveContext()
            tableData.append(newObject)
//            tableView.reloadData()
            let newIndexPath=IndexPath(row:tableData.count-1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath{
            print("Came from edit")
            let nav = segue.destination as! UINavigationController
            let dest = nav.topViewController as! AddItemVC
            dest.editText=tableData[indexPath.row].text!
            dest.indexPath=indexPath
        }
        else{
            print("Came from add button")
        }
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
        cell.textLabel?.text=tableData[indexPath.row].text
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AddSegue", sender: indexPath)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction=UIContextualAction(style: .destructive, title: "Delete", handler: {
            action, view, finishAnimation in
            self.delete(indexPath)
            finishAnimation(true)
        })
       let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    func delete(_ indexPath: IndexPath){
        managedObjectContext.delete(tableData[indexPath.row])
        saveContext()
        fetchAllItems()
//        tableData.remove(at: indexPath.row)
        tableView.deleteRows(at:[indexPath], with: .fade)
//        tableView.reloadData()
    }
}
