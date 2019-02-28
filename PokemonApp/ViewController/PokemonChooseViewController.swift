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
    
    var image: UIImage!
    var catchCounter = 0
    var pokemons = [Pokemon]()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //downloadPikachus(count: 15)
        
        trainerImageView.image = image
        updateLabel()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let completion: (Pokemon)->() = { (pokemon) in
            self.pokemons.append(pokemon)
            DispatchQueue.main.async { self.collectionView.reloadData() }
        }
        let service = PokemonService.shared
        service.downloadPokemon(name: "charmander", completion: completion)
        service.downloadPokemon(name: "charizard", completion: completion)
        service.downloadPokemon(name: "blastoise", completion: completion)
        service.downloadPokemon(name: "snorlax", completion: completion)
        service.downloadPokemon(name: "jigglypuff", completion: completion)
        service.downloadPokemon(name: "mewtwo", completion: completion)
    }
    
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
        pokemons.remove(at: index)
        
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
        if let pokemonImage = pokemons[indexPath.row].image {
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! PokemonCollectionViewCell
        let pokemon = pokemons[indexPath.row]
        if let imageData = pokemon.image {
            let image = UIImage(data: imageData)
            cell.imageView.image = image
        }
        else {
            cell.imageView.image = nil
        }
        cell.label.text = pokemon.name
        return cell
    }
    
}
