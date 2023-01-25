//
//  MyPageViewController.swift
//  SocialLogin
//
//  Created by 소하 on 2023/01/25.
//

import Foundation
import UIKit
import GoogleSignIn

class MyPageViewController : UIViewController {
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var labelEmail:UILabel!
    @IBOutlet weak var labelName:UILabel!
    
    var userData:UserData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 로그인 확인 후 프로필 로드
        loadProfile()
    }
}

extension MyPageViewController {
    // 프로필 가져오기
    func loadProfile() {
        guard let userData = userData else { return }
        imgProfile.image = userData.profile
        labelName.text = userData.name
        labelEmail.text = userData.email
    }
    // 로그아웃
    func logout() {
        GIDSignIn.sharedInstance.signOut()
        
        // 메인 화면으로 이동
        let board = UIStoryboard(name: "Main", bundle: nil)
        guard let nextVC = board.instantiateViewController(withIdentifier: "Main") as? ViewController else { return }
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true)
    }
}

extension MyPageViewController {
    // 로그아웃 버튼 클릭
    @IBAction func clickLogout(_ sender:Any) {
        logout()
    }
}
