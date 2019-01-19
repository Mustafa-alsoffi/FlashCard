//
//  ViewController.swift
//  FlashCard
//
//  Created by Mustafa Alsoffi on 15/01/2019.
//  Copyright © 2019 Mustafa Alsoffi. All rights reserved.
//

import UIKit



class FlashyCardViewController: UITableViewController {
    
    var items = [ItemsData]()
    
let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    
    
    

    //    var lastSelection: NSIndexPath!
//        var defaluts = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems ()
//                if let item = defaluts.array(forKey: "TopicsArray") as? [ItemsData] {
//                    items = item
//                }
//
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celly", for: indexPath)
        
        // set the text from the data model
        //        cell.textLabel?.text = items[indexPath.row]
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        // the code below is the equvlant of the if-statement below it and it's called ternary-operator
        cell.accessoryType = item.done ? .checkmark : .none

        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//
//        } else {
//            cell.accessoryType = .none
//
//        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // Rather than the if-statement here we used  the "!" to  reverse the boolean in the items array proprty ".done".
        items[indexPath.row].done = !items[indexPath.row].done
        self.saveData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    @IBAction func addItmesPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        
        //The alert view
        let alert = UIAlertController(title: "Add a topic name", message: "", preferredStyle: .alert)
        //The alert action
        let action = UIAlertAction(title: "Add name", style: .default) { (action) in
            
            
            //This if-statement is for the whitespaces
            if (textField.text?.hasPrefix(" "))! || (textField.text?.hasSuffix(" "))! || textField.text == " " || textField.text == ""{
                
                let alert2 = UIAlertController(title: "Sorry", message: "You can't have white spaces in your topic's name.", preferredStyle: .alert)
                let action2 = UIAlertAction(title: "Dismiss", style: .default, handler: { (action2) in
                    
                })
                
                alert2.addAction(action2)
                self.present(alert2, animated: true, completion: nil)
            } else {
                let newItem = ItemsData()
                newItem.title = textField.text!
                self.items.append(newItem)
                self.saveData()
//                                self.defaluts.set(self.items, forKey: "TopicsArray");
                
                
               
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveData() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.items)
            try data.write(to: self.dataFilePath!)
             self.tableView.reloadData()
        } catch {
            print("Erorr encoding item array, \(error)")
        }
        
       
    }
    
    func loadItems () {
        let decoder = PropertyListDecoder()
        if  let data = try? Data(contentsOf: dataFilePath!) {
            do {
                items = try decoder.decode([ItemsData].self, from: data)
            } catch {
                print("Error decoding items array \(error)")
            }
            self.tableView.reloadData()
        }
    }
    
   
}
