//
//  ViewController.swift
//  ToDo
//
//  Created by Jean martin Kyssama on 26/09/2019.
//  Copyright © 2019 Jean martin Kyssama. All rights reserved.
//

import UIKit

class ItemViewController: UITableViewController {
    var itemArray = [Item]()
    
    // user defaults
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let item1 = Item()
        item1.title = "Genese"
        itemArray.append(item1)
        
        let item2 = Item()
        item2.title = "Exode"
        itemArray.append(item2)
        
        let item3 = Item()
        item3.title = "Levitique"
        itemArray.append(item3)
        
        // on charge les donnees sauvegardees dans user defaults
        if let items = defaults.array(forKey: "ItemList") as? [Item] {
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
        
        cell.textLabel?.text = indexPathRow.title
        
        // en fonction de la propriete 'done' on affiche ou pas le 'checkmark'
        if indexPathRow.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        //cell.accessoryType = .none
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        // on change la propriete 'done' de l'element chaque fois qu'on clique sur celui-ci
        itemArray[indexPath.row].done.toggle()
        // et on recharge la table pour prendre en compte le changement de propriete
        tableView.reloadData()
     // petite animation sympa
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK : - Ajout nouvel element
    
    @IBAction func AjoutNouvelElement(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Nouvel élément", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ajouter", style: .default) { (alertAction) in
            // ce qui se passe quand on clique sur 'Ajouter'
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
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

