//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Kevin Yu on 2/28/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

class Pokemon: Decodable {
    var name: String
    var image: Data?
    var sprites: Sprites
    
    // var imageURL: String
    /*
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case sprites = "sprites"
    }
    */
    init(name: String, imageURL: String, sprites: Sprites) {
        self.name = name
        // self.imageURL = imageURL
        self.sprites = sprites
    }
}

struct Sprites: Decodable {
    var front_shiny: String
}
