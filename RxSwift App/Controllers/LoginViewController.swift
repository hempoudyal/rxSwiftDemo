//
//  LoginViewController.swift
//  RxSwift App
//
//  Created by Hem Poudyal on 01.09.21.
//

import UIKit
import RxCocoa
import RxSwift
import RxCocoa

class LoginViewController: ViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let bag = DisposeBag()
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        self.title = "Login"
        
        let observableCombined = Observable.combineLatest(self.userNameTextField.rx.text.orEmpty, self.passwordTextField.rx.text.orEmpty) //combine into one observable sequence
        
        self.loginButton.rx.tap
            .withLatestFrom(observableCombined)
            .subscribe(onNext: {
                self.login(user: $0, pass: $1)
            }).disposed(by: bag)
    }
    
    func login(user: String, pass: String){
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailText = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        let emailValid: Bool = emailText.evaluate(with: user)
        let passValid: Bool = (pass != "" && pass.count >= 6)
        
        if (emailValid && passValid){
            let foodListVC = self.storyboard?.instantiateViewController(identifier: "FoodListVC") as! ViewController
            self.navigationController?.pushViewController(foodListVC, animated: true)
        }
    }
}
