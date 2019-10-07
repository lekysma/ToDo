//
//  SwipeTableViewController.swift
//  ToDo
//
//  Created by Jean martin Kyssama on 07/10/2019.
//  Copyright © 2019 Jean martin Kyssama. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // on change la taille des cellules pour tous les VC enfants
        tableView.rowHeight = 80.0
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // implementation des caracteristiques de SwipeTableview 
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        return cell
    }
    
    //MARK: - Gestion Swipe gestures
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            // on appelle la fonction MAJ en general ici : le code ecrit au niveau local sera appelé ici
            self.MajDesCellules(at: indexPath)
            
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "image-corbeille")
        
        return [deleteAction]
    }
    
    // Autre mode pour effacer par swipe long vers la gauche
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    //MARK: Fonction qui servira pour la MAJ des modeles
    func MajDesCellules(at indexPath: IndexPath) {
        
    }

}
