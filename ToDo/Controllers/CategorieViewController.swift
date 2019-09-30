//
//  CategorieViewController.swift
//  ToDo
//
//  Created by Jean martin Kyssama on 30/09/2019.
//  Copyright © 2019 Jean martin Kyssama. All rights reserved.
//

import UIKit
import CoreData


class CategorieViewController: UITableViewController {
    
    //context et tableau contenant les categories
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categorieArray = [Categorie]()

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
            let newCategorie = Categorie(context: self.context)
            newCategorie.name = CategorieTextField.text
            self.categorieArray.append(newCategorie)
            
            self.sauvegardeCategorie()
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
        return categorieArray.count
    }
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategorieCell", for: indexPath)
        let indexPathRow = categorieArray[indexPath.row]
        
        cell.textLabel?.text = indexPathRow.name
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
            destinationVC.selectedCategory = categorieArray[indexpath.row]
        }
    }
    
    //MARK: - Data manipulations methods
    func sauvegardeCategorie() {
        do {
            try context.save()
        } catch {
            print("Impossible de sauvegarder la catégorie, \(error)")
        }
        
        tableView.reloadData()
    }
    //
    func chargementCategories() {
        let request: NSFetchRequest<Categorie> = Categorie.fetchRequest()
        do {
            categorieArray = try context.fetch(request)
        } catch {
            print("Impossible de charger les catégories\(error)")
        }
        
        tableView.reloadData()
    }
    
    
    

}
