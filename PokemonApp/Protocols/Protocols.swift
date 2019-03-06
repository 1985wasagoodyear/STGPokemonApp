//
//  Protocols.swift
//  PokemonApp
//
//  Created by Kevin Yu on 2/28/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//
import UIKit

protocol TrainerSelectDelegate: class {
    func didSelectTrainer(image: UIImage, tag: Int)
}

protocol CapturePokemonDelegate: class {
    func catchPokemon(at index: Int)
}
