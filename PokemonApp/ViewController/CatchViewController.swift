//
//  CatchViewController.swift
//  PokemonApp
//
//  Created by Kevin Yu on 3/7/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class CatchViewController: UIViewController {
    
    @IBOutlet var pokemonImageView: UIImageView!
    @IBOutlet var pokeBall: UIImageView!
    
    var pokemonImage: UIImage!
    var delegate: CapturePokemonDelegate!
    var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonImageView.image = pokemonImage
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(catchAction))
        pokeBall.addGestureRecognizer(tapGesture)
    }
    
    @objc func catchAction() {
        let duration = 1.5
        let group = CAAnimationGroup()
        
        let xanim = CAKeyframeAnimation(keyPath: "transform.translation.x")
        xanim.duration = duration
        let dest = pokeBall.center.x - pokemonImageView.center.x
        xanim.values = [0.0, -dest]
        xanim.keyTimes = [0.0, 1.0]
        
        let yanim = CAKeyframeAnimation(keyPath: "transform.translation.y")
        yanim.duration = duration
        let dest2 = pokeBall.center.y - pokemonImageView.center.y
        yanim.values = [0.0, -dest2]
        yanim.keyTimes = [0.0, 1.0]
        
        group.duration = duration
        group.animations = [xanim, yanim]
        group.delegate = self
        group.isRemovedOnCompletion = false // needs this as it was removed prematurely
        pokeBall.layer.add(group, forKey: "catchAnimation")
    }
}

extension CatchViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // remove animation when found & finished
        if flag && anim == pokeBall.layer.animation(forKey: "catchAnimation") {
            pokeBall.layer.removeAnimation(forKey: "catchAnimation")
            makePokemonDisappear()
        }
        else if flag && anim == pokemonImageView.layer.animation(forKey: "shrinkPokemon") {
            pokemonImageView.isHidden = true
            pokeBall.layer.removeAnimation(forKey: "shrinkPokemon")
            presentCongrats()
        }
        else if flag && anim == pokemonImageView.layer.animation(forKey: "catchAnimation") {
            pokeBall.layer.removeAnimation(forKey: "catchAnimation")
        }
    }
    
    func makePokemonDisappear() {
        // hide pokeball
        pokeBall.isHidden = true
        
        // make pokemon spin, fade shrink
        let group = CAAnimationGroup()
        let duration: CGFloat = 1.5
        group.duration = CFTimeInterval(duration)
        let spin = BasicAnimations.spinAnimation(duration)
        let fade = BasicAnimations.fadeAnimation(duration)
        let shrink = BasicAnimations.scaleAnimation(duration, to: 0.0)
        group.animations = [spin, fade, shrink]
        group.delegate = self
        group.isRemovedOnCompletion = false
        pokemonImageView.layer.add(group, forKey: "shrinkPokemon")
    }
    
    func presentCongrats() {
        let deletePokemon: (UIAlertAction)->Void = { _ in
            // do capturing logic before heading back as viewWillAppear causes race-condition
            self.delegate?.finishCapture()
            self.dismiss(animated: true, completion: nil)
        }
        
        let alert = UIAlertController(title: "You caught a Pokemon!",
                                      message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Awesome",
                                      style: .default, handler: deletePokemon)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
}
