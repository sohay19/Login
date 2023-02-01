//
//  ViewController.swift
//  Login
//
//  Created by 소하 on 2023/01/25.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {
    @IBOutlet weak var btnGoogleLogin: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 버튼 스타일 설정
        btnGoogleLogin.colorScheme = .light
        btnGoogleLogin.style = .wide
        
        // 기존에 로그인한 경우 바로 페이지 이동
        checkState()
    }
}

//MARK: - Google Login
extension ViewController {
    // 기존 로그인 상태 확인
    func checkState() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // 비로그인 상태
                print("Not Sign In")
            } else {
                // 로그인 상태
                guard let user = user else { return }
                guard let profile = user.profile else { return }
                // 유저 데이터 로드
                self.loadUserData(profile)
            }
        }
    }
    // 구글 로그인
    func googleLogin() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else {
                // 로그인 실패 시
                let popup = UIAlertController(title: "로그인 실패", message: "다시 로그인해주세요", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default)
                popup.addAction(action)
                self.present(popup, animated: true)
                return
            }
            // 로그인 성공 시
            guard let user = signInResult?.user else { return }
            guard let profile = user.profile else { return }
            // 유저 데이터 로드
            self.loadUserData(profile)
        }
    }
    // 유저 데이터 전달
    func loadUserData(_ profile:GIDProfileData) {
        let emailAddress = profile.email
        let fullName = profile.name
        let profilePicUrl = profile.imageURL(withDimension: 180)
        
        // 이미지 다운로드
        if let profilePicUrl = profilePicUrl {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: profilePicUrl) {
                    if let image = UIImage(data: data) {
                        // UI는 main thread에서만 접근가능
                        DispatchQueue.main.async {
                            let data = UserData(profile: image, name: fullName, email: emailAddress)
                            self.moveMyPage(data)
                        }
                    }
                }
            }
        }
    }
    // 마이페이지 이동
    func moveMyPage(_ data:UserData) {
        let board = UIStoryboard(name: "MyPage", bundle: nil)
        guard let nextVC = board.instantiateViewController(withIdentifier: "MyPage") as? MyPageViewController else { return }
        nextVC.userData = data
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true)
    }
}

//MARK: - Event
extension ViewController {
    @IBAction func clickGoogleLogin(_ sender:Any) {
        googleLogin()
    }
}
