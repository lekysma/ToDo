//
//  CategorieViewController.swift
//  ToDo
//
//  Created by Jean martin Kyssama on 30/09/2019.
//  Copyright © 2019 Jean martin Kyssama. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategorieViewController: SwipeTableViewController {
    
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
            //
            newCategorie.cellColor = (UIColor.randomFlat()?.hexValue())!
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
        
        let indexPathRow = ToDoCategorie?[indexPath.row]
        //Apparence de la cellule
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = indexPathRow?.name ?? "Aucune catégorie pour le moment !"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        //couleur cellule
        cell.backgroundColor = UIColor(hexString: indexPathRow?.cellColor)
        
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
    
    //MARK: - gestion de la suppression via Swipe et Realm
    override func MajDesCellules(at indexPath: IndexPath) {
        // Optional binding
        if let CategorieASupprimer = ToDoCategorie?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(CategorieASupprimer)
                    print("Catégorie supprimée !")
                }
            } catch {
                print("Impossible de supprimer la categorie, \(error)")
            }
            
        }
    }
    
    
    
    

}
