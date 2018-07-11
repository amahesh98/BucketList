//
//  AddItemVC.swift
//  BucketListDemo
//
//  Created by Ashwin Mahesh on 7/10/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit

class AddItemVC: UITableViewController {
    var editText:String = ""
    var indexPath:IndexPath?
    @IBOutlet weak var textField: UITextField!
    @IBAction func cancelPushed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func savePushed(_ sender: UIBarButtonItem) {
        if let text=textField.text{
            if text.count>0{
                performSegue(withIdentifier: "UnwindSegue", sender: sender)
            }
            return
        }
       return
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text=editText
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}
