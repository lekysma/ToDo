//
//  ViewController.swift
//  ToDo
//
//  Created by Jean martin Kyssama on 26/09/2019.
//  Copyright © 2019 Jean martin Kyssama. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ItemViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //on initialise Realm
    let realm = try! Realm()
    // variable de type results pour utiliser R de CRUD avec Realm
    var ToDoItems: Results<Item>?
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
    }
    
    //MARK: - Gere l'aspect de la barre de navigation qui devrait avoir la meme couleur que celle de la categorie selectionnee
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.cellColor {
            
            // verification pour s'assurer que l'application fonctionne parfaitement a ce niveau
            guard let navBar = navigationController?.navigationBar else {fatalError("La barre de navigation n'est pas présente !")}
            // on s'assure que le titre de la barre de navigation pour l'item porte le nom de la categorie selectionnee
            navigationItem.title = selectedCategory?.name
            
            if let navBarColor = UIColor(hexString: colorHex) {
                // on donne a la barre de navigation la meme couleur que celle de la cellule de la categorie selectionnee
                navBar.barTintColor = navBarColor
                // on harmonise aussi la couleur de la barre de recherche
                searchBar.barTintColor = navBarColor
                // et on donne un constraste au menu 'retour arriere' et 'ajouter un nouvel item'
                navBar.tintColor = ContrastColorOf(backgroundColor: navBarColor, returnFlat: true)
                // on donne une couleur harmonisée au titre de la barre de navigation pour les items
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(backgroundColor: navBarColor, returnFlat: true)]
            }
            
        }
    }
    
    //MARK: - S'assurer de revenir a la couleur originale de la barre de navigation une fois qu'on quitte la liste d'items
    override func viewWillDisappear(_ animated: Bool) {
        if let originalColors = UIColor(hexString: "66OOCC") {
            //couleur barre de navigation
            navigationController?.navigationBar.barTintColor = originalColors
            //couleur des menus 'retour en arriere' et 'nouvel item'
            navigationController?.navigationBar.tintColor = FlatBlue()
            // texte barre de navigation
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: FlatWhite()]        }
    }
    
    //MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // si ToDoItems n'est pas nul, on retourne le count, sinon on retourne 1
        return ToDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //Apparence de la cellule
        if let indexPathRow = ToDoItems?[indexPath.row] {
            cell.textLabel?.text = indexPathRow.title
            cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 18)
            
            //on s'assure de rendre chaque cellule succesivement plus sombre et qui herite de la couleur de sa categorie
            if let color = UIColor(hexString: selectedCategory?.cellColor).darken(byPercentage:CGFloat(indexPath.row) / CGFloat(ToDoItems!.count)) {
                cell.backgroundColor = color
                // on donne un contraste a la couleur du texte en fonction de la couleur de la cellule
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
            }
            // en fonction de la propriete 'done' on affiche ou pas le 'checkmark'
            if indexPathRow.done == true {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            cell.textLabel?.text = "Aucun item ajouté pour l'instant"
        }
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = ToDoItems?[indexPath.row] {
            do {
                // on sauvegarde le tout dans Realm
                try realm.write {
                     // on change la propriete 'done' de l'element chaque fois qu'on clique sur celui-ci
                    item.done.toggle()
                    
                    // pour effacer un element le code sera:
//                    realm.delete(item)
                }
            } catch {
                print("Impossible de sauvegarder le changement de proprieté 'done', \(error)")
            }
        }
        
        tableView.reloadData()
        //petite animation cool
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK : - Ajout nouvel element
    
    @IBAction func AjoutNouvelElement(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Nouvel élément", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ajouter", style: .default) { (alertAction) in
            // ce qui se passe quand on clique sur 'Ajouter'
            if let currentCategorie = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        //pas besoin de proprieté 'done' car la valeur par defaut est deja donnee dans la classe mere
                        currentCategorie.items.append(newItem)
                    }
    
                } catch {
                    print("Impossible de sauvegarder dans Realm, \(error)")
                }
                self.tableView.reloadData()
            }
            

        }
        
        alert.addAction(action)
        alert.addTextField { (UITextField) in
            textField = UITextField
            textField.placeholder = "Tapez ici"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Data manipulation methods
    func chargementElements() {
        
        // on charge les donnees identifiees par titre, pas d'ordre alphabetique
        ToDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: false)

        tableView.reloadData()
    }
    
    // MARK: - Gestion de la suppression d'un item via Swipe et Realm
    override func MajDesCellules(at indexPath: IndexPath) {
        if let itemASupprimer = ToDoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(itemASupprimer)
                    print("Succès ! Item supprimé !")
                }
            } catch {
                print("Impossible de supprimer l'item, \(error)")
            }
        }
    }
    
}

//MARK: - Search bar functionalities
extension ItemViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // code pour afficher et trier donnees recherches. on ne charge pas les resultats alphabetiquement
        //PS : Pas besoin de charger les donnees avec Realm.
        ToDoItems = ToDoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: false)
        //et on recharge la table
        tableView.reloadData()
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

