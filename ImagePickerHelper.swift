//
//  ImagePickerHelper.swift
//  ImagePicker
//
//  Created by Roobaan M T on 04/02/23.
//

import UIKit
import AVFoundation
import Photos

class ImagePickerHelper : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let shared = ImagePickerHelper()
    
    var viewController: UIViewController?
    var imagePicker = UIImagePickerController()
    var completionHandler: ((UIImage?) -> Void)?
    
    
    // it shows the alert to choose the type to pick or capture image from mobile
    func showImagePickerAlert(controller: UIViewController, completionHandler: @escaping (UIImage?) -> Void) {
        self.viewController = controller
        self.completionHandler = completionHandler
        let alertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { (_) in
                self.checkCameraPermission()
            }
            alertController.addAction(cameraAction)
        }
        
        let galleryAction = UIAlertAction(title: "Choose From Gallery", style: .default) { (_) in
            self.checkPhotoLibraryPermission()
            
        }
        alertController.addAction(galleryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    //it opens the camera in the mobile
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true   // it helps to edit the photo that choosen from mobile
            viewController?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //it displays the photo library of your mobile
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            DispatchQueue.main.async { [self] in
                
                imagePicker.delegate = self
                
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                viewController?.present(imagePicker, animated: true, completion: nil)
            }}
    }
    
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        if let assetURL = info [UIImagePickerController.InfoKey.referenceURL] as? URL {
//            let result = PHAsset.fetchAssets(withALAssetURLs: [assetURL], options: nil)
//            let asset = result.firstObject
//            print(assetURL)
//            print(result)
//            print()
//
//        }
        
        print("delegate")
        var selectedImage: UIImage?
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
        }
        completionHandler?(selectedImage)
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    // delegate function will trigger when the user cancel the action
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
        completionHandler?(nil)
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    // to check the permisssion status of the camera
    func checkCameraPermission() {
        
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined: self.requestCameraPermission()
        case .authorized: self.openCamera()
        case .restricted, .denied: self.alertAccessNeeded(access: "Camera")
        default:
            break
        }
    }
    
    // to check the permisssion status of the photo library
    func checkPhotoLibraryPermission() {
        let photolibraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photolibraryAuthorizationStatus{
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    self.openGallery()
                }
            })
        case .authorized:
            self.openGallery()
            
        case .denied, .restricted:
            self.alertAccessNeeded(access: "Photos")
            
        default:
            break
        }
    }
    
    // request permission from user to access camera
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            
            guard accessGranted == true else { return }
            DispatchQueue.main.async {
                self.openCamera()           }
        })
    }
    
    // if the access is denied before, this function will make navigate to settings to enable permission
    func alertAccessNeeded(access: String) {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Need \(access) Access",
            message: "\(access) access is required to make full use of this app.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow \(access)", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    
    
}
