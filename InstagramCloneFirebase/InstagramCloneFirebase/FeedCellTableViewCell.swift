//
//  FeedCellTableViewCell.swift
//  InstagramCloneFirebase
//
//  Created by Yavuz Güner on 10.07.2022.
//

import UIKit
import Firebase

class FeedCellTableViewCell: UITableViewCell {

    @IBOutlet weak var documentLabel: UILabel!
    
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonClicked(_ sender: Any) {
        
        let fireStoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!) {
            
            let likeStore = ["likes" : likeCount + 1] as [String:Any]
            
            fireStoreDatabase.collection("Posts").document(documentLabel.text!).setData(likeStore, merge: true)
        }
        
        
    }
}
