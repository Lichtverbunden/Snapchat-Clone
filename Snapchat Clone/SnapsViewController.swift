//
//  SnapsViewController.swift
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

class SnapsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    var snaps: [Snap] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            
            let snap = Snap()
            
            snap.imageURL = (snapshot.value as! NSDictionary)["imageURL"] as! String
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.descrip = (snapshot.value as! NSDictionary)["description"] as! String
            snap.key = snapshot.key
            snap.uuid = (snapshot.value as! NSDictionary)["uuid"] as! String
            
            self.snaps.append(snap)
            self.tableView.reloadData()
        })
        
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childRemoved, with: {(snapshot) in
            print(snapshot)
            
            
            var index = 0
            
            for snap in self.snaps
            {
                if snap.key == snapshot.key
                {
                    self.snaps.remove(at: index)
                }
                print(index)
                index += 1
            }
            
            self.tableView.reloadData()
        })

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if snaps.count == 0
        {
            return 1
        }
        else
        {
            return snaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        if snaps.count == 0
        {
            cell.textLabel?.text = "You have no snaps. 😞"
        }
        else
        {
            let snap = snaps[indexPath.row]
            
            cell.textLabel?.text = snap.from
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if snaps.count == 0
        {
            
        }
        else
        {
            let snap = snaps[indexPath.row]
            
            performSegue(withIdentifier: "viewSnapSegue", sender: snap)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "viewSnapSegue"
        {
            let nextVC = segue.destination as! ViewSnapViewController
        
            nextVC.snap = sender as! Snap
        }
    }
    
    @IBAction func logoutTapped(_ sender: AnyObject)
    {
        dismiss(animated: true, completion: nil)
    }
}
