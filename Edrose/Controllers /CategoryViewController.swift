//
//  CategoryViewController.swift
//  Edrose
//
//  Created by Mustafa Alsoffi on 21/01/2019.
//  Copyright © 2019 Mustafa Alsoffi. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController{
    
    var category = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    


    override func viewDidLoad() {
        super.viewDidLoad()
        loadICategories ()

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
    let item = category[indexPath.row]
    
    cell.textLabel?.text = item.name
    
    return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Hi!", message: "Add a category here", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add here", style: .default) { (action) in
            
            //This if-statement is for the whitespaces
            if (textField.text?.hasPrefix(" "))! || (textField.text?.hasSuffix(" "))! || textField.text == " " || textField.text == ""{
                
                let alert2 = UIAlertController(title: "Sorry", message: "You can't have white spaces in your topic's name.", preferredStyle: .alert)
                let action2 = UIAlertAction(title: "Dismiss", style: .default, handler: { (action2) in
                    
                })
                
                alert2.addAction(action2)
                self.present(alert2, animated: true, completion: nil)
            } else {
                
                
                let newItem = Category(context: self.context)
                newItem.name = textField.text!
            
                self.category.append(newItem)
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
    
    func loadICategories (with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            category =  try context.fetch(request)
        } catch {
            print("Error fetching data from context -> \(error)")
        }
        self.tableView.reloadData()
    }
    
    

}

