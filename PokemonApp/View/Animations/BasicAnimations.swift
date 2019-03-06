//
//  BasicAnimations.swift
//  PokemonApp
//
//  Created by Kevin Yu on 3/6/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

struct BasicAnimations {
    
    static func spinAnimation(_ duration: CGFloat) -> CABasicAnimation {
        let spinA = CABasicAnimation(keyPath: "transform.rotation")
        spinA.duration = CFTimeInterval(duration)
        spinA.toValue = .pi * 2.0
        return spinA
    }
    
    static func fadeAnimation(_ duration: CGFloat) -> CAKeyframeAnimation {
        let fadeA = CAKeyframeAnimation(keyPath: "opacity")
        fadeA.duration = CFTimeInterval(duration)
        fadeA.values = [1.0, 0.0, 1.0, 0.0, 1.0]
        fadeA.keyTimes = [0.0, 0.50, 0.75, 0.90, 1.0]
        return fadeA
    }
    
    static func bounce(_ height: CGFloat, _ duration: CGFloat) -> CAKeyframeAnimation {
        let startPos = 0.0
        
        let bounceA = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounceA.duration = 5.0
        bounceA.values = [startPos, startPos - 10.0,
                          startPos, startPos - 30.0,
                          startPos, -height,
                          startPos, -height - 30.0,
                          startPos, startPos - 30.0,
                          startPos, startPos - 10.0,
                          startPos]
        var keyTimes = [NSNumber]()
        let size = Double(bounceA.values!.count)
        for i in 0..<bounceA.values!.count {
            keyTimes.append(NSNumber(value: (Double(i) * 1.0)/size))
        }
        bounceA.keyTimes = keyTimes // can be omitted, will make linear keytimes
        return bounceA
    }
    
    static func bounceAndSpin(_ height: CGFloat, _ _duration: CGFloat) -> CAAnimationGroup {
        let group = CAAnimationGroup()
        let duration = CFTimeInterval(_duration)
        
        // spinning animation
        let spinA = BasicAnimations.spinAnimation(_duration)
        
        // bouncing animation
        let bounceA = BasicAnimations.bounce(height, _duration)
        
        group.duration = duration
        group.animations = [spinA, bounceA]
        
        return group
    }
    
    static func spinAndFade(_ height: CGFloat, _ _duration: CGFloat) -> CAAnimationGroup {
        let duration = 3.0
        let group = CAAnimationGroup()
        
        // spinning animation
        let spinA = BasicAnimations.spinAnimation(_duration)
        
        // fading animation
        let fadeA = BasicAnimations.fadeAnimation(_duration)
        
        group.duration = duration
        group.animations = [spinA, fadeA]
        
        return group
    }
    
}

