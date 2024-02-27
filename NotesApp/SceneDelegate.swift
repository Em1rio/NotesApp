//
//  SceneDelegate.swift
//  NotesApp
//
//  Created by Emir Nasyrov on 24.02.2024.
//

import UIKit
import RealmSwift

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                }
            })
        Realm.Configuration.defaultConfiguration = config
        do {
            _ = try Realm()
        } catch let error as NSError {
            print("Ошибка открытия базы данных: \(error.localizedDescription)")
        }
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let databaseManager = DBManager()
        let viewModel = ListOfNotesViewModel(databaseManager)
        let viewController = ListOfNotesViewController(viewModel)
        let navController = UINavigationController(rootViewController: viewController)
        viewController.navController = navController
        navController.navigationBar.prefersLargeTitles = true
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
    
   
}

