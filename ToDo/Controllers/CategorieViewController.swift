//
//  CategorieViewController.swift
//  ToDo
//
//  Created by Jean martin Kyssama on 30/09/2019.
//  Copyright © 2019 Jean martin Kyssama. All rights reserved.
//

import UIKit
import RealmSwift


class CategorieViewController: UITableViewController {
    
    //initialisation de Realm
    let realm = try! Realm()
    // variable de type Results qui renferme des objets de classe Categorie
    var ToDoCategorie: Results<Categorie>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chargementCategories()

    }


    
    //MARK: - ajout nouvelle categorie
    @IBAction func boutonNouvelleCategorie(_ sender: UIBarButtonItem) {
        
        var CategorieTextField = UITextField()
        let alert = UIAlertController(title: "Nouvelle catégorie", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ajouter", style: .default) { (alertAction) in
            // l'action se passe ici
            let newCategorie = Categorie()
            newCategorie.name = CategorieTextField.text!
            //pas besoin d'ajouter a un tableau avec Realm car la MAJ se fait automatiquement
            
            self.sauvegarde(categorie: newCategorie)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (UITextField) in
            CategorieTextField = UITextField
            CategorieTextField.placeholder = "Tapez ici"
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ToDoCategorie?.count ?? 1
        //Autre syntaxe
//        if categorieArray != nil {
//            return categorieArray!.count
//        } else {
//            return 1
//        }
    }
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategorieCell", for: indexPath)
        let indexPathRow = ToDoCategorie?[indexPath.row]
        
        cell.textLabel?.text = indexPathRow?.name ?? "Aucune catégorie pour le moment !"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        
        return cell
    }
    
    //MARK: - table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print("segue")
        performSegue(withIdentifier: "versItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = ToDoCategorie?[indexpath.row]
        }
    }
    
    //MARK: - Data manipulations methods
    func sauvegarde(categorie: Categorie) {
        do {
            try realm.write {
                realm.add(categorie)
            }
        } catch {
            print("Impossible de sauvegarder la catégorie, \(error)")
        }
        
        tableView.reloadData()
    }
    //
    func chargementCategories() {
        ToDoCategorie = realm.objects(Categorie.self)
        tableView.reloadData()
    }
    
    
    

}
