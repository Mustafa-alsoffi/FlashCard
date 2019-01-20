//
//  ViewController.swift
//  FlashCard
//
//  Created by Mustafa Alsoffi on 15/01/2019.
//  Copyright © 2019 Mustafa Alsoffi. All rights reserved.
//

import UIKit
import CoreData



class FlashyCardViewController: UITableViewController {
    
    var items = [Item]()
    
//let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    //        var defaluts = UserDefaults.standard

     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
loadItems ()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        loadItems ()
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
        
        
        // the oreder of the two lines down below this comment is important
//        context.delete(items[indexPath.row])
//        items.remove(at: indexPath.row)
        items[indexPath.row].done = !items[indexPath.row].done
        self.saveData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    @IBAction func addItmesPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        
        //The alert view
        let alert = UIAlertController(title: "Add something here", message: "", preferredStyle: .alert)
        //The alert action
        let action = UIAlertAction(title: "Add a name", style: .default) { (action) in
            
            
            //This if-statement is for the whitespaces
            if (textField.text?.hasPrefix(" "))! || (textField.text?.hasSuffix(" "))! || textField.text == " " || textField.text == ""{
                
                let alert2 = UIAlertController(title: "Sorry", message: "You can't have white spaces in your topic's name.", preferredStyle: .alert)
                let action2 = UIAlertAction(title: "Dismiss", style: .default, handler: { (action2) in
                    
                })
                
                alert2.addAction(action2)
                self.present(alert2, animated: true, completion: nil)
            } else {
                
               
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
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
        
        do {
          try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
       self.tableView.reloadData()
    }
    
    //Load Data
    func loadItems (with request: NSFetchRequest<Item> = Item.fetchRequest()) {
    
    do {
       items =  try context.fetch(request)
    } catch {
        print("Error fetching data from context -> \(error)")
    }
    self.tableView.reloadData()
  }
    
   
}

//MARK: - Search bat method

extension FlashyCardViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
      
       request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]//ascending means sort in an alphpetic oreder
        
        loadItems(with: request)
      
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
