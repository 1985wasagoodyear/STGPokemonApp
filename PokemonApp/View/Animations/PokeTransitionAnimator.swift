//
//  PokeTransitionAnimator.swift
//  UltraPokemonFlare
//
//  Created by Kevin Yu on 11/27/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

import UIKit
import Darwin

final class PokeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let animationTime: TimeInterval = 1.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        let currVC = transitionContext.view(forKey: .from)!
        let nextVC = transitionContext.view(forKey: .to)!
        
        container.addSubview(nextVC)
        currVC.alpha = 1.0
        nextVC.alpha = 0.0
        
        UIView.animate(withDuration: animationTime, animations: {
            currVC.alpha = 0.0
            nextVC.alpha = 1.0
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}

class PokeShrinkAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let animationTime: TimeInterval = 3.0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationTime * 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        let currVC = transitionContext.view(forKey: .from)!
        let nextVC = transitionContext.view(forKey: .to)!
        
        let middleX = currVC.center.x
        
        let fullSize = currVC.frame
        let shrinkToFrame = CGRect(x: middleX,
                                   y: 0,
                                   width: 0,
                                   height: currVC.frame.size.height)
        /*
        let groupAni = CAAnimationGroup()
        
        let animation1 = CABasicAnimation(keyPath: "transform.scale.x")
        animation1.fromValue = 0
        animation1.toValue = 1.0
        currVC.layer.add(animation1, forKey: "ani1")
        */
        UIView.animate(withDuration: animationTime, animations: {
            // currVC.frame = shrinkToFrame
            let scale: CGFloat = 0.00000000000001
            let rotate = CGAffineTransform(rotationAngle: 720.0)
            currVC.transform = CGAffineTransform(scaleX: scale,
                                                 y: scale).concatenating(rotate)
        }) { [unowned self] _ in
            container.addSubview(nextVC)
            nextVC.frame = shrinkToFrame
            
            UIView.animate(withDuration: self.animationTime, animations: {
                nextVC.frame = fullSize
            }) { _ in
                transitionContext.completeTransition(true)
            }
        }
        
        
    }
}

