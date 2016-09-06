//
//  ViewSnapViewController.swift
//  Snapchat Clone
//
//  Created by Ken Krippeler on 06.09.16.
//  Copyright © 2016 Lichtverbunden. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ViewSnapViewController: UIViewController
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var snap = Snap()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        label.text = snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imageURL))
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").child(snap.key).removeValue()
        
        FIRStorage.storage().reference().child("images").child("\(snap.uuid).jpg").delete { (error) in
            print("We deleted the picture!")
        }
    }
}
