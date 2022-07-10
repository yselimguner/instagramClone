//
//  ProfileViewController.swift
//  InstagramCloneFirebase
//
//  Created by Yavuz Güner on 9.07.2022.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileTableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var userImageArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        getDataFromFirestore()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("error")
        }
    }
    
    func getDataFromFirestore(){
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("SharePhoto").order(by: "date", descending: true)
            .addSnapshotListener { (snapshot,error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)

                    
                    
                   
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        
                        if let photoDescription = document.get("sharePhotoDescription") as? String {
                            self.userCommentArray.append(photoDescription)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    self.profileTableView.reloadData()
            }
        }
        
    }
    
    

}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for:indexPath) as! ProfileTableViewCell
        
        cell.descriptionTextView.text = userCommentArray[indexPath.row]
        cell.profilePhotoImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.emailLabel.text = userEmailArray[indexPath.row]
        
        return cell
    }
}
