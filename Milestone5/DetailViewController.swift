//
//  DetailViewController.swift
//  Milestone5
//
//  Created by Khalid Kamil on 12/31/20.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedPhotoCaption: String?
    var selectedPhoto: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        title = selectedPhotoCaption
        if let photoToLoad = selectedPhoto {
            imageView.image = photoToLoad
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

}
