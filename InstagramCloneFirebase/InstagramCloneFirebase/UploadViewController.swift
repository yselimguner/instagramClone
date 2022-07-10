//
//  UploadViewController.swift
//  InstagramCloneFirebase
//
//  Created by Yavuz Güner on 9.07.2022.
//

import UIKit
import Firebase

class UploadViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    @objc func chooseImage(){
        let pickerControler = UIImagePickerController()
        pickerControler.delegate = self
        pickerControler.sourceType = .photoLibrary
        present(pickerControler, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        //Bunun içerisine kaydedeceğiz resimleri
        let mediaFolder = storageReference.child("media")
        
        //Datayı yarısı kadar boyuta sıkıştırıp kaydederiz.
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
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
                            
                            let firestorePost = ["imageUrl": imageUrl!, "postedBy":Auth.auth().currentUser!.email!, "postComment":self.commentText.text!, "date": FieldValue.serverTimestamp(), "likes":0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                                }
                                else {
                                    self.imageView.image = UIImage(named: "taptoselect.png")
                                    self.commentText.text = ""
                                    //Bizi işi bittikten sonra hangi indexe götüreceğini söylüyoruz.
                                    self.tabBarController?.selectedIndex = 0
                                }
                                
                            })
                            
                            
                        }
                    }
                }
            }
        }
        
    }
}
