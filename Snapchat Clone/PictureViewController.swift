//
//  PictureViewController.swift
//  Snapchat Clone
//
//  Created by Ken Krippeler on 03.09.16.
//  Copyright © 2016 Lichtverbunden. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var uuid = NSUUID().uuidString
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self
        nextButton.isEnabled = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = image
        
        imageView.backgroundColor = UIColor.clear
        
        nextButton.isEnabled = true
        
        imagePicker.dismiss(animated: true, completion: nil)
    
    }
    
    @IBAction func cameraTapped(_ sender: AnyObject)
    {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func nextTapped(_ sender: AnyObject)
    {
        nextButton.isEnabled = false
        
        let imagesFolder = FIRStorage.storage().reference().child("images")
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        
        imagesFolder.child("\(uuid).jpg").put(imageData, metadata: nil)
        {
            (metadata, error) in
            print("We tried to upload.")
            if error != nil
            {
                print("We had an error: \(error)")
            }
            else
            {
                print(metadata?.downloadURL())
                
                self.performSegue(withIdentifier: "selectUserSegue", sender: metadata?.downloadURL()!.absoluteString)
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
       let nextVC = segue.destination as! SelectUserViewController
        
        nextVC.imageURL = sender as! String
        nextVC.descrip = descriptionTextField.text!
        nextVC.uuid = uuid
    }

}
