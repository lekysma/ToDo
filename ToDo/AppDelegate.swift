//
//  AppDelegate.swift
//  ToDo
//
//  Created by Jean martin Kyssama on 26/09/2019.
//  Copyright © 2019 Jean martin Kyssama. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //chemin d'acces pour visualiser le fichier realm
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        // on initialise realm
        
        do {
             let realm = try Realm()
            try realm.write {
            }
        } catch {
            print("Erreur dans la sauvegarde en utilisant Realm, \(error)")
        }
        return true
    }
    
}

