//
//  ImagePickerManager.swift
//  iSocFit
//
//  Created by makintosh on 19.04.2021.
//

import UIKit
import Photos

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((_ img: UIImage, _ str: String) -> ())?;
    
    override init(){
            super.init()
            let cameraAction = UIAlertAction(title: "Camera", style: .default){
                UIAlertAction in
                self.openCamera()
            }
            let galleryAction = UIAlertAction(title: "Gallery", style: .default){
                UIAlertAction in
                self.openGallery()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
                UIAlertAction in
            }

            // Add the actions
            picker.delegate = self
            alert.addAction(cameraAction)
            alert.addAction(galleryAction)
            alert.addAction(cancelAction)
        }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage, String) -> ())) {
            pickImageCallback = callback;
            self.viewController = viewController;

            alert.popoverPresentationController?.sourceView = self.viewController!.view

            viewController.present(alert, animated: true, completion: nil)
        }
        func openCamera(){
            alert.dismiss(animated: true, completion: nil)
            if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                picker.sourceType = .camera
                self.viewController!.present(picker, animated: true, completion: nil)
            } else {
                let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
                alertWarning.show()
            }
        }
        func openGallery(){
            alert.dismiss(animated: true, completion: nil)
            picker.sourceType = .photoLibrary
            self.viewController!.present(picker, animated: true, completion: nil)
        }

        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
        //for swift below 4.2
        //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //    picker.dismiss(animated: true, completion: nil)
        //    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //    pickImageCallback?(image)
        //}
        
        // For Swift 4.2+
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            guard let image = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            
            
            let url = info[.imageURL] as? URL
            let fileName = url!.lastPathComponent
            
            print("____________________________________")
            print(fileName)
            
            pickImageCallback?(image, fileName)
        }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
        }

    
}
