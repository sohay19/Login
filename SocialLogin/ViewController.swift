//
//  ViewController.swift
//  Login
//
//  Created by 소하 on 2023/01/25.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

//MARK: - Google Login
extension ViewController {
    func googleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) {
            user, error in
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                PopupManager.shared.openOkAlert(self, title: "알림", msg:"로그인 실패\n\(String(describing: error))")
                return
            }
            
            //
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { [self]
                authResult, error in
                guard let result = authResult else {
                    if let LoginError = error {
                        let authError = LoginError as NSError
                        if authError.code != AuthErrorCode.secondFactorRequired.rawValue {
                            PopupManager.shared.openOkAlert(self, title: "알림", msg:"로그인 중 오류가 발생하였습니다.")
                        }
                    }
                    return
                }
                loginType = LoginType.Google
                
                loginSuccess(result.user)
            }
        }
    }
}
