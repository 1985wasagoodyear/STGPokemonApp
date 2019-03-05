//
//  Sprites+CoreDataClass.swift
//  PokemonApp
//
//  Created by Kevin Yu on 3/5/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Sprites)
public class Sprites: NSManagedObject, Decodable {

    enum CodingKeys: String, CodingKey {
        case frontShiny = "front_shiny"
        case frontFemale = "front_female"
        case frontDefault = "front_default"
        case backDefault = "back_default"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext else {
            throw NSError(domain: "Context not found!", code: 0, userInfo: nil)
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Sprites", in: context) else {
            throw NSError(domain: "Could not make Entity", code: 0, userInfo: nil)
        }
        
        super.init(entity: entity, insertInto: context)
        frontShiny = try container.decode(String.self, forKey: .frontShiny)
        frontFemale = try container.decodeIfPresent(String.self, forKey: .frontFemale)
        frontDefault = try container.decode(String.self, forKey: .frontDefault)
        backDefault = try container.decode(String.self, forKey: .backDefault)
    }

    
}
