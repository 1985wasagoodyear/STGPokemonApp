//
//  Trainer+CoreDataProperties.swift
//  PokemonApp
//
//  Created by Kevin Yu on 3/5/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//
//

import Foundation
import CoreData


extension Trainer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trainer> {
        return NSFetchRequest<Trainer>(entityName: "Trainer")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var pokemon: NSOrderedSet?

}

// MARK: Generated accessors for pokemon
extension Trainer {

    @objc(insertObject:inPokemonAtIndex:)
    @NSManaged public func insertIntoPokemon(_ value: Pokemon, at idx: Int)

    @objc(removeObjectFromPokemonAtIndex:)
    @NSManaged public func removeFromPokemon(at idx: Int)

    @objc(insertPokemon:atIndexes:)
    @NSManaged public func insertIntoPokemon(_ values: [Pokemon], at indexes: NSIndexSet)

    @objc(removePokemonAtIndexes:)
    @NSManaged public func removeFromPokemon(at indexes: NSIndexSet)

    @objc(replaceObjectInPokemonAtIndex:withObject:)
    @NSManaged public func replacePokemon(at idx: Int, with value: Pokemon)

    @objc(replacePokemonAtIndexes:withPokemon:)
    @NSManaged public func replacePokemon(at indexes: NSIndexSet, with values: [Pokemon])

    @objc(addPokemonObject:)
    @NSManaged public func addToPokemon(_ value: Pokemon)

    @objc(removePokemonObject:)
    @NSManaged public func removeFromPokemon(_ value: Pokemon)

    @objc(addPokemon:)
    @NSManaged public func addToPokemon(_ values: NSOrderedSet)

    @objc(removePokemon:)
    @NSManaged public func removeFromPokemon(_ values: NSOrderedSet)

}


extension Trainer {
    func setImage(data: Data) {
        self.image = NSData(data: data)
    }
    func getImageData() -> Data? {
        guard let im = self.image else { return nil }
        return Data(referencing: im)
    }
}
