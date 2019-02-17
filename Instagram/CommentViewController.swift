//
//  CommentViewController.swift
//  Instagram
//
//  Created by 増田弘毅 on 2019/02/11.
//  Copyright © 2019 rebirthbtn24. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class CommentViewController: UIViewController {

    var postData: PostData?
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // 投稿ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handlePostButton(_ sender: Any) {

        // Firebaseに保存するデータの準備
        let comment = "\(Auth.auth().currentUser!.displayName!) :  \(textField.text!)"
        postData!.comments.append(comment)
        
        // Firebaseに保存する
        let postRef = Database.database().reference().child(Const.PostPath).child((postData?.id!)!)
        let comments = ["comment": postData!.comments]
        postRef.updateChildValues(comments)
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "コメント投稿しました")
        
        // 全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // キャンセルボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleCancelButton(_ sender: Any) {
        // 画面を閉じる
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.delegate = self as? UITextFieldDelegate
        
        
        /*
        // 受け取った画像をImageViewに設定する
        imageView.image = image
        */
        
        setPostData(postData!)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.view.endEditing(true)
    }
    
    func setPostData(_ postData: PostData) {
        self.postImageView.image = postData.image
        
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: postData.date!)
        self.dateLabel.text = dateString
        
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
    
    
}

