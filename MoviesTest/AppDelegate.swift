//
//  AppDelegate.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 11/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit
import CoreData

var context: NSManagedObjectContext! {
    return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}
extension NSManagedObjectContext {
    func saveIfHasChanged() {
        if hasChanges {
            do {
                try save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Attributes -
    var window: UIWindow?

    // MARK: - Application Life Cycle -
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        startApplication()
        
        return true
    }
    
    // MARK: - Utils -
    private func startApplication() {
        let rootController = HomeBuilder().build().inBaseNavigation()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoviesTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

}

