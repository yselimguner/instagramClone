//
//  ProfileTableViewCell.swift
//  InstagramCloneFirebase
//
//  Created by Yavuz Güner on 10.07.2022.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
