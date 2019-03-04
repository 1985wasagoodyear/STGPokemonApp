//
//  PokedexViewController.swift
//  PokemonApp
//
//  Created by Kevin Yu on 3/4/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController {

    let MAX_TOTAL_POKEMON = 151
    var pokemons = [Int:Pokemon]()
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // start by downloading some Pokemon
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
        for i in 0..<30 {
            dispatchGroup.enter()
            service.downloadPokemon(name: String(i+1)) { (pokemon) in
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

}

extension PokedexViewController: UICollectionViewDataSource {
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
        // reminder: MAX_TOTAL_POKEMON is a constant for the end index of pokemon, 151
        if self.pokemons.count == MAX_TOTAL_POKEMON { return }
        if indexPath.row == (self.pokemons.count - 3) {
            let dispatchGroup = DispatchGroup()
            
            let completion: (Pokemon, Int)->() = { (pokemon, index) in
                self.pokemons[index] = pokemon
                dispatchGroup.leave()
            }
            let service = PokemonService.shared
            let max = (self.pokemons.count + 9 > MAX_TOTAL_POKEMON) ? MAX_TOTAL_POKEMON - self.pokemons.count : 9
            for i in 0..<max {
                let index = self.pokemons.count + i
                print(index)
                dispatchGroup.enter()
                service.downloadPokemon(name: String(index + 1)) { (pokemon) in
                    completion(pokemon, index)
                }
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                self.collectionView.reloadData()
                print("Did finish downloading Pokemon: \(self.pokemons.count)")
            }
        }
    }
    
    private func setImage(cell: PokemonCollectionViewCell, pokemon: Pokemon) {
        if let imageData = pokemon.image {
            let image = UIImage(data: imageData)
            cell.imageView.image = image
        }
        else {
            cell.imageView.image = nil
            PokemonService.shared.downloadPicture(for: pokemon) { (pokemon) in
                if let imageData = pokemon.image {
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData)
                        cell.imageView.image = image
                    }
                }
            }
        }
    }
}

extension PokedexViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        // animateCell(cell: collectionView.cellForItem(at: indexPath))
        
        collectionView.layer.add(bounceBlinkAnimation(), forKey: "asdjkahjkldas")
    }
    
    func animateCell(cell myCell: UICollectionViewCell) {
        let cell = myCell as! PokemonCollectionViewCell

        cell.imageView.layer.add(bounceBlinkAnimation(), forKey: "blinkSpinWaveAnimation")
    }
    
    func bounceBlinkAnimation() -> CAAnimationGroup {
        let duration = 3.0
        let width = self.view.frame.size.width
        
        let group = CAAnimationGroup()
        group.duration = duration
        
        let xAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        xAnimation.fromValue = -width
        xAnimation.toValue = width
        xAnimation.duration = duration
        
        let yAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        yAnimation.values = [0.0, 100.0, -100.0, 100.0, -100.0, 0.0]
        yAnimation.duration = duration
        
        let blink = CAKeyframeAnimation(keyPath: "opacity")
        blink.values = [1.0, 0.0, 1.0, 0.0, 1.0]
        blink.duration = duration
        
        let spin = CABasicAnimation(keyPath: "transform.rotation")
        spin.fromValue = 0.0
        spin.toValue = (Double.pi * 2.0)
        spin.duration = duration
        
        group.animations = [xAnimation, yAnimation, blink, spin]
        
        return group
    }
}

extension PokedexViewController: UICollectionViewDelegateFlowLayout {
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
