//
//  AppDelegate.swift
//  PokemonApp
//
//  Created by Kevin Yu on 2/27/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var rootVC: UIViewController! = nil
        
        // is there a trainer?
        let service = CoreDataService()
        
        deleteWildPokemon(service)
        // testDeleteTrainer(service)
        
        if service.checkIfTrainerExists() {
            // if yes, go to signed-in screen
            rootVC = storyboard.instantiateViewController(withIdentifier: "SignedInExperience")
        }
        else {
            // if not, trainer select
            rootVC = storyboard.instantiateViewController(withIdentifier: "TrainerPageViewController")
        }
        
        window?.rootViewController = rootVC
        
        
        return true
    }

    func deleteWildPokemon(_ service: CoreDataService) {
        
        // how many pokemon are saved?
        var num = service.printNumOfPokemon()
        print("We have \(num)-many Pokemon saved")
        
        // delete all wild Pokemon
        service.deleteAllWildPokemon()
        
        // how many pokemon are saved?
        num = service.printNumOfPokemon()
        print("We now have only \(num)-many Pokemon saved")
    }
    
    func testDeleteTrainer(_ service: CoreDataService) {
        // delete Sandra
        // save context
        service.deleteTrainer()
        // check amount of all pokemon currently saved
        print("Deleted Trainer, \(service.printNumOfPokemon()) still exist")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

