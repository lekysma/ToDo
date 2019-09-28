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
    // Affiche le chemin d'acces vers le lieu ou on encode nos elements ajoutes
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(dataFilePath)
        
        // on charge les donnees sauvegardees dans user defaults
//        if let items = defaults.array(forKey: "ItemList") as? [Item] {
//            itemArray = items
//        }

        
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
        // et on sauvegarde
        sauvegardeElements()
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
            // on encode les elements ajoutees
            self.sauvegardeElements()
        }
        
        alert.addAction(action)
        alert.addTextField { (UITextField) in
            textField = UITextField
            textField.placeholder = "Tapez ici"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Data manipulation methods
    func sauvegardeElements() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Impossible d'encoder les éléments, \(error)")
        }
        // on recharge la table pour prendre en compte les nouveaux changements
        tableView.reloadData()
    }
    
    

}

