//
//  ViewController.swift
//  ImagePicker
//
//  Created by Roobaan M T on 04/03/23.
//

import UIKit
import Photos
import AVFoundation

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    
    var im : ImagePickerHelper!
    //
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
//        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 5
        imageView.layer.masksToBounds = true
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        return imageView
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        
        button.setTitle("click", for: .normal)
        button.setTitleColor(.systemBrown, for: .normal)
//        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 5
        return button
    }()
    
    let color: [UIColor] = [.systemRed, .systemYellow , .systemBlue, .systemCyan, .systemPink, .systemGray]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        view.backgroundColor = .systemRed
        view.addSubview(imageView)
        view.addSubview(button)
        
        imageView.center = view.center
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect(x: 20,
                              y: view.frame.size.height-view.safeAreaInsets.bottom-50,
                              width: view.frame.size.width-50,
                              height: 20)
        
    }
    
    
    
    @objc func didTapButton(){
        
        imagetapp()
    }
    
    
    func imagetapp() {
        ImagePickerHelper.shared.showImagePickerAlert(controller: self, completionHandler: {  (image) in
                    guard let imagePic = image else{return}
                    DispatchQueue.main.async {
                        self.imageView.image = imagePic
                   }
                }
            )
    }
}




