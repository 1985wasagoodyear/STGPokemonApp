//
//  CoreDataService.swift
//  CoreDataSuperExample
//
//  Created by Kevin Yu on 3/5/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation
import CoreData

/*
 Core Data Stack
 (top to bottom)
 1. NSManagedObjectContext(m)  - Context
 2. PersistStoreCoordinator(s) - Coordinator(?)
 3. PersistentContainer(s)
 4. NSManagedObjects(m)        - Core Data Items/Entities/Objects
 
 4. Describe the objects in your Core Data stack
    -MUST be created & managed in your Context
 
 3. PersistentContainer == Disk/place where data is saved
 2. Coordinator = manages how you perform saving
 
 1. Context == represents your RAM/memory
    -load data into memory
    -save data into disk
    -create items/update items/delete items
    -undo changes
    -temporary
    -NSManagedObjects MUST be created & managed here
    -not thread safe (we'll go into this later)
 */

/*
 .xcdatamodel - file that describes your NSManagedObjects
 attributes / properties of your objects
 relationships of your objects
 a few other things
 
 */

extension CodingUserInfoKey {
    static let context: CodingUserInfoKey = CodingUserInfoKey(rawValue: "NSManagedObjectContext")!
}

class CoreDataService {
    
    // MARK: - Core Data stack
    
    // computed property
    /// for main-thread use, only.
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    // if we wanted to create our own context manually:
    /*
    lazy var context: NSManagedObjectContext =  {
        let c = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        c.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return c
    }()
    */
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PokemonApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

/// all trainer-related stuff here
extension CoreDataService {
    func createTrainer(_ image: Data, _ name: String,
                       _ completion: @escaping (Trainer)->Void) {
        persistentContainer.performBackgroundTask { (context) in
            let trainer = NSEntityDescription.insertNewObject(forEntityName: "Trainer",
                                                              into: context) as! Trainer
            
            trainer.name = name
            trainer.image = NSData(data: image)
            
            try! context.save()
            completion(trainer)
        }
    }
    
    func checkIfTrainerExists() -> Bool {
        // let fetch = NSFetchRequest<Trainer>(entityName: "Trainer")
        let fetch: NSFetchRequest = Trainer.fetchRequest()
        do {
            let results = try context.fetch(fetch)
            return results.count > 0
        }
        catch {}
        return false
    }
    
    func loadTrainer() -> Trainer? {
        let fetch: NSFetchRequest = Trainer.fetchRequest()
        do {
            let results = try context.fetch(fetch)
            return results.first
        }
        catch {}
        return nil
    }
}

extension CoreDataService {
    func printNumOfPokemon() -> Int {
        let fetch: NSFetchRequest = Pokemon.fetchRequest()
        do {
            let results = try context.fetch(fetch)
            return results.count
        }
        catch {}
        return 0
    }
    
    func deleteAllWildPokemon() {
        let fetch: NSFetchRequest = Pokemon.fetchRequest()
        do {
            let results = try context.fetch(fetch)
            for result in results {
                if result.trainer == nil {
                    context.delete(result)
                }
            }
            saveContext()
        }
        catch {}
    }
    
    func deleteTrainer() {
        let fetch: NSFetchRequest = Trainer.fetchRequest()
        do {
            let results = try context.fetch(fetch)
            for result in results {
                context.delete(result)
            }
            saveContext()
        }
        catch {}
    }
}
