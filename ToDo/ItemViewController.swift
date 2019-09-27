//
//  ViewController.swift
//  ToDo
//
//  Created by Jean martin Kyssama on 26/09/2019.
//  Copyright © 2019 Jean martin Kyssama. All rights reserved.
//

import UIKit

class ItemViewController: UITableViewController {
    var itemArray = ["Genese", "Exode", "Levitique"]
    
    // user defaults
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // on charge les donnees sauvegardees dans user defaults
        if let items = defaults.array(forKey: "ItemList") as? [String] {
            itemArray = items
        }
    }
    
    //MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let indexPathRow = itemArray[indexPath.row]
        
        cell.textLabel?.text = indexPathRow
        
        //cell.accessoryType = .none
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        //coche cellule selectionee
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    // MARK : - Ajout nouvel element
    
    @IBAction func AjoutNouvelElement(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Nouvel élément", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ajouter", style: .default) { (alertAction) in
            // ce qui se passe quand on clique sur 'Ajouter'
            self.itemArray.append(textField.text!)
            // on sauvegarde dans user defaults
            self.defaults.set(self.itemArray, forKey: "ItemList")
//            //on recharge la table pour afficher le nouvel ajout
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { (UITextField) in
            textField = UITextField
            textField.placeholder = "Tapez ici"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    

}

