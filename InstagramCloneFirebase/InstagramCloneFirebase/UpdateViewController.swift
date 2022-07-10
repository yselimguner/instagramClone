//
//  UpdateViewController.swift
//  InstagramCloneFirebase
//
//  Created by Yavuz Güner on 10.07.2022.
//

import UIKit
import Firebase

class UpdateViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var nameLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profilImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        profilImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage(){
        let pickerControler = UIImagePickerController()
        pickerControler.delegate = self
        pickerControler.sourceType = .photoLibrary
        present(pickerControler, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profilImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func updateButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        //Bunun içerisine kaydedeceğiz resimleri
        let mediaFolder = storageReference.child("profile")
        
        //Datayı yarısı kadar boyuta sıkıştırıp kaydederiz.
        if let data = profilImageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg") //buradaki image.jpg'i değiştiririz çünkü her kaydettiğimizde üzerine yazar. Bu yüzden yukarıya uuid tanımlarız.
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            //DATABASE alanı.
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestoreProfile = ["imageUrl": imageUrl!, "userName":self.nameLabel.text!, "userDescription":self.descriptionTextField.text!, "date": FieldValue.serverTimestamp() ] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("UserProfile").addDocument(data: firestoreProfile, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                                }
                                else {
                                    self.nameLabel.text = "Your name"
                                    self.profilImageView.image = UIImage(named: "taptoselect.png")
                                    self.descriptionTextField.text = "Write the description"
                                    //Bizi işi bittikten sonra hangi indexe götüreceğini söylüyoruz.
                                    
                                    
                                }
                                
                            })
                            
                            
                        }
                    }
                }
            }
        }
        
    }
    
    
}
