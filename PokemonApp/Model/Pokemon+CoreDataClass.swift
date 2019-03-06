//
//  Pokemon+CoreDataClass.swift
//  PokemonApp
//
//  Created by Kevin Yu on 3/5/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Pokemon)
public class Pokemon: NSManagedObject, Decodable {

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case sprite = "sprites"
    }
    
    // why does this work
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext else {
            throw NSError(domain: "Context not found!", code: 0, userInfo: nil)
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Pokemon", in: context) else {
            throw NSError(domain: "Could not make Entity", code: 0, userInfo: nil)
        }
        
        super.init(entity: entity, insertInto: context)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        sprite = try container.decodeIfPresent(Sprites.self, forKey: .sprite)
    }
}
