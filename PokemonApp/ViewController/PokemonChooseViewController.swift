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
        trainerImageView.image = image
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.downloadPikachus(count: 15)
    }
    
    func downloadPikachus(count: Int) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/pikachu"
        for _ in 0..<count {
            guard let url = URL(string: urlString) else {
                // throw an error about invalid URL
                return
            }
            
            var request = URLRequest(url: url,
                                     cachePolicy: .returnCacheDataElseLoad,
                                     timeoutInterval: 10.0)
            request.httpMethod = "GET"
            let config = URLSessionConfiguration.default
            config.allowsCellularAccess = false
            config.requestCachePolicy = .returnCacheDataElseLoad
            let session = URLSession.init(configuration: config)
            
            // option 2:
            // let sess = URLSession.shared
            
            // actual downloading/uploading task
            let dataTask = session.dataTask(with: request)
            { (data, response, error) in
                if let dat = data {
                    // parse the data
                    let decoder = JSONDecoder()
                    do {
                        // make a pokemon
                        let pokemon = try decoder.decode(Pokemon.self, from: dat)
                        
                        self.downloadPicture(for: pokemon)
                    }
                    catch {
                        // error, something
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func downloadPicture(for pokemon: Pokemon) {
        guard let url = URL(string: pokemon.sprites.front_shiny) else {
            // error here
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            pokemon.image = data
            
            // add it into our pokemons
            self.pokemons.append(pokemon)
            print("Did download Pokemon! Count: \(self.pokemons.count)")
        }.resume()
    }
}

extension PokemonChooseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // catch the pokemon
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
        return UICollectionViewCell()
    }
    
}
