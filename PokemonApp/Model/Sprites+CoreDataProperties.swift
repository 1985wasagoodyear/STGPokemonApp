//
//  Sprites+CoreDataProperties.swift
//  PokemonApp
//
//  Created by Kevin Yu on 3/5/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//
//

import Foundation
import CoreData


extension Sprites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sprites> {
        return NSFetchRequest<Sprites>(entityName: "Sprites")
    }

    @NSManaged public var frontShiny: String
    @NSManaged public var frontFemale: String?
    @NSManaged public var frontDefault: String
    @NSManaged public var backDefault: String
    @NSManaged public var pokemon: Pokemon?

}
