//
//  ViewController.swift
//  ToDo
//
//  Created by Jean martin Kyssama on 26/09/2019.
//  Copyright © 2019 Jean martin Kyssama. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UITableViewController {
    var itemArray = [Item]()
    //creation du context pour toutes les operations CRUD
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //permet d'associer les items a leur categorie parent
    var selectedCategory : Categorie? {
        didSet {
            //chargement des elements liés a la categorie selectionnee
            chargementElements()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
         // Affiche le chemin d'acces vers le lieu ou on encode nos elements ajoutes
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let indexPathRow = itemArray[indexPath.row]
        
        cell.textLabel?.text = indexPathRow.title
        cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 18)
        
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
//        // pour effacer un element du contexte et de la table, voici la marche a suivre : 1st du context puis de la table
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        // on change la propriete 'done' de l'element chaque fois qu'on clique sur celui-ci
        itemArray[indexPath.row].done.toggle()
        // et on sauvegarde (U de CRUD)
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
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            //categorie parent
            newItem.parentCategorie = self.selectedCategory
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
        do {
            try context.save()
        } catch {
            print("Impossible de sauvegarder dans le context, \(error)")
        }
        // on recharge la table pour prendre en compte les nouveaux changements
        tableView.reloadData()
    }
    //
    func chargementElements(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let CategoriePredicate = NSPredicate(format: "parentCategorie.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [CategoriePredicate, additionalPredicate])
        } else {
            request.predicate = CategoriePredicate
        }
        //
        do {
            itemArray = try context.fetch(request)
            
        } catch {
            print("Erreur dans le chargement des données à partir du contexte, \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - Search bar functionalities
extension ItemViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // en premier, on charge les donnees via une requete
        let request: NSFetchRequest<Item> = Item.fetchRequest()

        //parametres recherches : l'attribut 'titre' contient le contenu tapé dans la barre de recherche
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // parametres tri des resultats recherchés : 'titre' par ordre croissant
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // ensuite on va chercher les donnees
        chargementElements(with: request, predicate: predicate)
    }
    
    //changer ou mettre fin a la recherche
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            // on recharge toutes les donnees
            chargementElements()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

