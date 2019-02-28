//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Kevin Yu on 2/28/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

/*
 open           - available to everyone & subclassable
 public         - available to everyone but can only subclass it in the module
 internal       - default, only available in the module
 fileprivate    - only available in the file
 private        - only available in the declared scope
*/

import Foundation

class Pokemon: Decodable {
    var name: String
    var image: Data?
    fileprivate var sprite: Sprites
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case sprite = "sprites"
    }
    
    init(name: String) {
        self.name = name
        self.sprite = Sprites(frontShiny: "", frontFemale: "",
                              frontDefault: "", backDefault: "")
    }
}

extension Array {
    func doubleArray() -> Array {
        return self + self
    }
}

// Decorator Design Pattern:
// add extra behavior, functionality, etc
// to an existing object
// without changing its source code
extension Pokemon {
    
    // var newThing: String?
    
    // computed property
    var randomImageURL: String {
        let rand = Int.random(in: 0..<4)
        switch (rand) {
        case 0:
            return sprite.frontShiny
        case 1:
            return sprite.frontFemale ?? sprite.frontDefault
        case 2:
            return sprite.frontDefault
        default:
            return sprite.backDefault
        }
    }
    func randomImURL() -> String {
        let rand = Int.random(in: 0..<4)
        switch (rand) {
        case 0:
            return sprite.frontShiny
        case 1:
            return sprite.frontFemale ?? sprite.frontDefault
        case 2:
            return sprite.frontDefault
        default:
            return sprite.backDefault
        }
    }
}

fileprivate struct Sprites: Decodable {
    var frontShiny: String
    var frontFemale: String?
    var frontDefault: String
    var backDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontShiny = "front_shiny"
        case frontFemale = "front_female"
        case frontDefault = "front_default"
        case backDefault = "back_default"
    }
}
