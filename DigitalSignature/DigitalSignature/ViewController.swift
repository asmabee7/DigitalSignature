//
//  ViewController.swift
//  SignatureApp
//
//  Created by asma.bee on 03/10/2024.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var signButton: UIButton!
    var signatureString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signButtonAction(_ sender: Any) {
        let signatureController = SignatureViewController(nibName: "SignatureViewController", bundle: Bundle.main)
        if let signatureString = signatureString {
            signatureController.signatureString = signatureString
        } else {
            signatureController.signatureString = ""
        }
        signatureController.callBack = { str in
            self.signatureString = str
            if let str = str {
                self.configureSuccessUI()
            } else {
                self.configureEmptyUI()
            }
        }

        self.navigationController?.pushViewController(signatureController, animated: true)
    }
    
    func configureSuccessUI() {
        signButton.setTitle("View", for: .normal)
    }
    
    func configureEmptyUI() {
        signButton.setTitle("Sign", for: .normal)

    }
}

