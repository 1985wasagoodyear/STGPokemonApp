//
//  Pokemon+SpritesUtility.swift
//  PokemonApp
//
//  Created by Kevin Yu on 3/5/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

extension Pokemon {
    func setImage(data: Data) {
        self.image = NSData(data: data)
    }
    func getImageData() -> Data? {
        guard let im = self.image else { return nil }
        return Data(referencing: im)
    }
}

extension Pokemon {
    var randomImageURL: String? {
        let rand = Int.random(in: 0..<4)
        switch (rand) {
        case 0:
            return sprite?.frontShiny
        case 1:
            return sprite?.frontFemale ?? sprite?.frontDefault
        case 2:
            return sprite?.frontDefault
        default:
            return sprite?.backDefault
        }
    }
}
