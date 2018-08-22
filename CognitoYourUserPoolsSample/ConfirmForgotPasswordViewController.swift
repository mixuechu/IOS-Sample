//
// Copyright 2014-2018 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License").
// You may not use this file except in compliance with the
// License. A copy of the License is located at
//
//     http://aws.amazon.com/asl/
//
// or in the "license" file accompanying this file. This file is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, express or implied. See the License
// for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import AWSCognitoIdentityProvider

class ConfirmForgotPasswordViewController: UIViewController,UITextFieldDelegate {
    
    var user: AWSCognitoIdentityUser?
    
    @IBOutlet weak var confirmationCode: UITextField!
    @IBOutlet weak var proposedPassword: UITextField!
    
    @IBOutlet weak var confirm: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        self.confirmationCode.delegate = self
        self.proposedPassword.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        self.confirmationCode.textColor = colour
        self.confirmationCode.add_placeholder(text: "验证码", color: colour)
        self.confirmationCode.setBottomBorder()
        self.proposedPassword.isSecureTextEntry = true
        self.proposedPassword.textColor = colour
        self.proposedPassword.add_placeholder(text: "新密码", color: colour)
        self.proposedPassword.setBottomBorder()
        
        self.confirm.backgroundColor = colour
        self.confirm.setTitleColor(sign_in_colour, for:.normal)
        
        
       self.navigationController?.navigationBar.isHidden = false
    }
    // MARK: - IBActions
    
    @IBAction func updatePassword(_ sender: AnyObject) {
        guard let confirmationCodeValue = self.confirmationCode.text, !confirmationCodeValue.isEmpty else {
            let alertController = UIAlertController(title: "信息不足",
                                                    message: "请输入新密码",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:  nil)
            return
        }
        
        //confirm forgot password with input from ui.
        self.user?.confirmForgotPassword(confirmationCodeValue, password: self.proposedPassword.text!).continueWith {[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    self?.present(alertController, animated: true, completion:  nil)
                } else {
                    let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                }
            })
            return nil
        }
    }
    
}
