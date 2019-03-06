//
//  PokemonCollectionViewCell.swift
//  PokemonApp
//
//  Created by Kevin Yu on 2/28/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView! {
        didSet {
            tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(tapGestureAction))
            tapGesture.numberOfTapsRequired = 1
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet var label: UILabel!
    
    var tapGesture: UITapGestureRecognizer!
    
    weak var delegate: CapturePokemonDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func tapGestureAction() {
        // tell the tableView that I want to capture a pokemon
        self.delegate?.catchPokemon(at: self.tag)
    }
    
}
