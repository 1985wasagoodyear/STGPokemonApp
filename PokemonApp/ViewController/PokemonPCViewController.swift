//
//  PokemonPCViewController.swift
//  PokemonApp
//
//  Created by Kevin Yu on 3/6/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class PokemonPCViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
}

extension PokemonPCViewController: UICollectionViewDelegateFlowLayout {
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

extension PokemonPCViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return PokemonService.shared.trainer.pokemon?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! PokemonCollectionViewCell
        // new change for dictionary-based storage
        guard let poke = PokemonService.shared.trainer.pokemon?[indexPath.row],
            let pokemon = poke as? Pokemon else {
            cell.label.text = "Error"
            cell.imageView.image = nil
            return cell
        }
        
        setImage(cell: cell, pokemon: pokemon)
        cell.label.text = pokemon.name
        cell.tag = indexPath.row
        return cell
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


