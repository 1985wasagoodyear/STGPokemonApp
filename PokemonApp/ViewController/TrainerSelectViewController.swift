//
//  TrainerSelectViewController.swift
//  PokemonApp
//
//  Created by Kevin Yu on 2/27/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class TrainerSelectViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = image
    }

    @IBAction func buttonAction(_ sender: Any) {
        // select this trainer & continue on with
        // your heroic pokemans adventure
    }
    
}

