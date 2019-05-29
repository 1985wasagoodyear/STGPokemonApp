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
    var pokemons = [Int:Pokemon]()
    var currentIndex: Int = 0
    private let tAnimator = PokeTransitionAnimator()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PokemonService.shared.loadTrainer()
        trainer = PokemonService.shared.trainer
        trainerImageView.image = UIImage(data: trainer.getImageData()!)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLabel()
        downloadPokemon()
    }
    
    func downloadPokemon() {
        // group setup
        let dispatchGroup = DispatchGroup()
        
        let completion: (Pokemon, Int)->() = { (pokemon, index) in
            self.pokemons[index] = pokemon
            dispatchGroup.leave()
        }
        // for each Pokemon we want to download,
        // 1. enter the group
        // 2. and perform download task
        let service = PokemonService.shared
        for i in 0..<Int.random(in: 5...30) {
            let pokemon = String(Int.random(in: 1...807))
            dispatchGroup.enter()
            service.downloadPokemon(name: pokemon) { (pokemon) in
                completion(pokemon, i)
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
    
    func updateLabel() {
        let count = trainer.pokemon?.count ?? 0
        catchCounterLabel.text = "Pokemon Caught: " + String(count)
    }
    
}

extension PokemonChooseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        // unused
    }
    
}

extension PokemonChooseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // width & height
        // CG = Core Graphics
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
        cell.delegate = self
        cell.tag = indexPath.row
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
            cell.imageView.image = UIImage(named: "wow")
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

extension PokemonChooseViewController: CapturePokemonDelegate {
    
    func catchPokemon(at index: Int) {
        currentIndex = index
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CatchViewController") as! CatchViewController
        vc.pokemonImage = UIImage(data: pokemons[index]!.getImageData()!)
        vc.delegate = self
        vc.transitioningDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func finishCapture() {
        // catch the pokemon:
        // remove pokemon from array
        
        // adjust for each index for dictionaries
        // remove last item
        guard let pokemon = self.pokemons[currentIndex] else {
            // error, bad index
            return
        }
        
        for i in currentIndex..<(self.pokemons.count - 1) {
            self.pokemons[i] = self.pokemons[i+1]
        }
        self.pokemons[self.pokemons.count-1] = nil
        pokemon.date = NSDate()
        self.trainer.addToPokemon(pokemon)
        PokemonService.shared.saveTrainer()
        
        // update label
        self.updateLabel()
        
        // reload collectionView
        self.collectionView.reloadData()
    }
}

extension PokemonChooseViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return tAnimator
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return tAnimator
    }

    
}
