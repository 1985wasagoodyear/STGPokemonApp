//
//  TrainerPageViewController.swift
//  PokemonApp
//
//  Created by Kevin Yu on 2/27/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class TrainerPageViewController: UIPageViewController {
    
    var trainerNames = ["sandra", "tom", "genghis"]
    var trainerVCs = [TrainerSelectViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // populate VC's
        let storyboard = self.storyboard ?? UIStoryboard(name: "Main", bundle: nil)
        for i in 0..<3 {
            let vc = storyboard.instantiateViewController(withIdentifier: "TrainerSelectViewController") as! TrainerSelectViewController
            // additional setup for vc
            vc.image = UIImage(named: trainerNames[i])
            vc.view.tag = i
            trainerVCs.append(vc)
        }
        // set up a VC for using photos
        let photoVC = storyboard.instantiateViewController(withIdentifier: "TrainerSelectViewController") as! TrainerSelectViewController
        photoVC.usePhotos = true
        photoVC.view.tag = trainerVCs.count
        trainerVCs.append(photoVC)
        
        self.delegate = self
        self.dataSource = self
        
        // determine what VCs are visible
        self.setViewControllers([trainerVCs[0]],
                                direction: .forward,
                                animated: false,
                                completion: nil)
        
    }
}

extension TrainerPageViewController: UIPageViewControllerDelegate { }

extension TrainerPageViewController: UIPageViewControllerDataSource {
    
    // MARK: - Mandatory for Scrolling Behavior
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = viewController.view.tag
        if currentIndex == 0 { return nil }
        
        return trainerVCs[currentIndex-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = viewController.view.tag
        if currentIndex >= trainerVCs.count - 1 { return nil }
        
        return trainerVCs[currentIndex+1]
    }
    
    // MARK: - PageControl functionality
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 1
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 1
    }
    
}
