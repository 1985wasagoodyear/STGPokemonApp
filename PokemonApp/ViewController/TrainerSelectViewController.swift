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
    
    var delegate: TrainerSelectDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // do different setup, for default image or user image
        if usePhotos == false {
            self.imageView.image = image
        }
        else {
            self.imageView.image = UIImage(named: "userPhotoPlaceholder")
            self.button.setTitle("Select Photo", for: .normal)
        }
    }

    @IBAction func buttonAction(_ sender: Any) {
        // do different action, for continuing or taking picture
        if usePhotos == true {
            // let user choose a photo
            let picker = UIImagePickerController()
            picker.delegate = self
            // prioritize selfies
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
        if let im = imageView.image {
            delegate?.didSelectTrainer(image: im, tag: self.view.tag)
        } else {
            // imageView.image is nil
            // do stuff here, present an alert, or something
        }
    }
    
}

extension TrainerSelectViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // get photo from info dictionary
        guard let photo = info[.originalImage] as? UIImage else {
            return
        }
        
        imageView.image = photo
        
        // change button to continue
        usePhotos = false
        button.setTitle("Select Trainer", for: .normal)
        
        // dismiss picker
        picker.dismiss(animated: true, completion: nil)
    }
}
