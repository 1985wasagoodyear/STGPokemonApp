//
//  Pokemon+CoreDataProperties.swift
//  PokemonApp
//
//  Created by Kevin Yu on 3/5/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//
//

import Foundation
import CoreData


extension Pokemon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pokemon> {
        return NSFetchRequest<Pokemon>(entityName: "Pokemon")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: NSData?
    @NSManaged public var date: NSDate?
    @NSManaged public var trainer: Trainer?
    @NSManaged public var sprite: Sprites?

}
