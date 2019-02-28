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
    var usePhotos: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if usePhotos == false {
            self.imageView.image = image
        }
        else {
            self.imageView.image = UIImage(named: "userPhotoPlaceholder")
            self.button.setTitle("Select Photo", for: .normal)
        }
    }

    @IBAction func buttonAction(_ sender: Any) {
        if usePhotos == true {
            // let user choose a photo
            let picker = UIImagePickerController()
            picker.delegate = self
            if UIImagePickerController.isCameraDeviceAvailable(.front) {
                picker.sourceType = .camera
                picker.cameraDevice = .front
            }
            else if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                picker.sourceType = .camera
                picker.cameraDevice = .rear
            }
            self.present(picker, animated: true, completion: nil)
            return
        }
        
        // select this trainer & continue on with
        // your heroic pokemans adventure
    }
    
}

extension TrainerSelectViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let photo = info[.originalImage] as? UIImage else {
            return
        }
        
        imageView.image = photo
        usePhotos = false
        button.setTitle("Select Trainer", for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
}
