//
//  PokemonChooseViewController.swift
//  PokemonApp
//
//  Created by Kevin Yu on 2/28/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class PokemonChooseViewController: UIViewController {
    
    // MARK: - Storyboard Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var trainerImageView: UIImageView!
    @IBOutlet var catchCounterLabel: UILabel!
    
    // MARK: - Properties
    
    var trainer: Trainer!
    var catchCounter = 0
    var pokemons = [Int:Pokemon]()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //downloadPikachus(count: 15)
        print("Welcome to Gringas Town, " + trainer.name!)
        trainerImageView.image = UIImage(data: trainer.getImageData()!)
        updateLabel()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // group setup
        let dispatchGroup = DispatchGroup()
        
        let completion: (Pokemon, Int)->() = { (pokemon, index) in
            self.pokemons[index] = pokemon
            dispatchGroup.leave()
        }
        // for each Pokemon we want to download,
        // 1. enter the group
        // 2. and perform download task
        let pokemons = ["charmander", "charizard",
                        "blastoise", "snorlax",
                        "jigglypuff", "mewtwo"]
        let service = PokemonService.shared
        for (index, pokemon) in pokemons.enumerated() {
            dispatchGroup.enter()
            service.downloadPokemon(name: pokemon) { (pokemon) in
                completion(pokemon, index)
            }
        }
        
        // work to do when all downloads are completed
        // is performed when # of leaves == # of enters
        // a given "enter" is not necessarily paired with a "leave"
        // * should be coded after dispatchGroup has at least 1 enter
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.collectionView.reloadData()
            print("Did finish downloading Pokemon: \(self.pokemons.count)")
        }
    }
    
    /*
    func downloadPikachus(count: Int) {
        let completion: (Pokemon)->() = { (pokemon) in
            // add it into our pokemons
            self.pokemons.append(pokemon)
            
            // dispatch work asynchronously to the main thread
            // UIKit must be done on the main thread
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            // print("Did download Pokemon! Count: \(self.pokemons.count)")
        }
        
        for _ in 0..<count {
            PokemonService.shared.downloadPokemon(name: "pikachu",
                                                  completion: completion)
        }
    }
    */
    func updateLabel() {
        catchCounterLabel.text = "Pokemon Caught: " + String(catchCounter)
    }
    
}

extension PokemonChooseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        // catch the pokemon:
        // remove pokemon from array
        let index = indexPath.row
        
        // adjust for each index for dictionaries
        // remove last item
        for i in index..<(pokemons.count - 1) {
            pokemons[i] = pokemons[i+1]
        }
        pokemons[pokemons.count-1] = nil
        
        // update counter
        catchCounter += 1
        
        // update label
        updateLabel()
        
        // reload collectionView
        collectionView.reloadData()
    }
}

extension PokemonChooseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // width & height
        // CG = Core Graphics
        if let pokemonImage = pokemons[indexPath.row]?.getImageData() {
            let image = UIImage(data: pokemonImage)!
            
            let size = CGSize(width: image.size.width,
                              height: image.size.height + 30.0)
            return size
        }
        let width = collectionView.frame.size.width / 3.0
        let height = width + 30.0
        let size = CGSize(width: width, height: height)
        return size
    }
}

extension PokemonChooseViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! PokemonCollectionViewCell
        // new change for dictionary-based storage
        guard let pokemon = pokemons[indexPath.row] else {
            cell.label.text = "Error"
            cell.imageView.image = nil
            return cell
        }
        
        setImage(cell: cell, pokemon: pokemon)
        cell.label.text = pokemon.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == (self.pokemons.count - 3) {
            // download next batch of Pokemon
            // on completion: reload CollectionView
        }
    }
    
    private func setImage(cell: PokemonCollectionViewCell, pokemon: Pokemon) {
        
        if let imageData = pokemon.getImageData() {
            let image = UIImage(data: imageData)
            cell.imageView.image = image
        }
        else {
            cell.imageView.image = nil
            PokemonService.shared.downloadPicture(for: pokemon) { (pokemon) in
                if let imageData = pokemon.getImageData() {
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData)
                        cell.imageView.image = image
                    }
                }
            }
        }
    }
    
}
