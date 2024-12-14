//
//  SignatureViewController.swift
//  PaperlessJourney
//
//  Created by asma.bee on 19/06/2023.
//  Copyright © 2023 Mobile DevOps. All rights reserved.
//

import UIKit

class SignatureViewController: UIViewController {
    @IBOutlet weak var checkbox: UIImageView?
    @IBOutlet weak var confirmButton: UIButton?
    @IBOutlet weak var infoLabel: UILabel?
    @IBOutlet weak var signatureView: SignatureCanvasView?
    var signatureString: String?
    var isChecked = false {
        didSet {
            setCheckbox(checked: isChecked)
        }
    }
    
    fileprivate var path = UIBezierPath()
    fileprivate var points = [CGPoint](repeating: CGPoint(), count: 5)
    fileprivate var controlPoint = 0
    var callBack: ((String?) -> ())?
    fileprivate weak var savedImageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        setUpSignature()
        addRightbarButtons()
        
        isChecked = false
        checkbox?.isUserInteractionEnabled = isChecked
        confirmButton?.isEnabled = isChecked
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkboxAction(_:)))
        checkbox?.isUserInteractionEnabled = true
        checkbox?.addGestureRecognizer(tapGestureRecognizer)
        confirmButton?.setTitle("Confirm", for: .normal)
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setImageFromString()
    }
    
    func setUpSignature() {
        signatureView?.layer.cornerRadius = 10
        signatureView?.contentMode = .scaleAspectFit
        signatureView?.callBack = { enable in
            //enable the checkbox only if user has signed on the canvas
            self.checkbox?.isUserInteractionEnabled = enable == true
        }
    }
    
    func addRightbarButtons() {
        let barButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(reset))
        navigationItem.rightBarButtonItem = barButtonItem
        self.navigationController?.navigationBar.topItem?.title = ""
    }

    @objc func checkboxAction(_ sender: Any) {
        isChecked = !isChecked
    }
    
    func setCheckbox(checked: Bool) {
        let image = isChecked ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
        checkbox?.image = image
        confirmButton?.isEnabled = isChecked
    }
    
    @objc func reset() {
        signatureView?.clear()
        //checkbox will be disbaled on reset
        isChecked = false
        self.checkbox?.isUserInteractionEnabled = isChecked
    }
        
    func setImageFromString() {
        if let signatureString = signatureString, signatureString.isEmpty == false {
            var image = UIImage()
            image = image.convertBase64ToImage(signatureString)
            self.signatureView?.image = resizeImage(image: image, size: self.signatureView?.frame.size)
            callBack?(signatureString)
        }
    }
    
    func resizeImage(image: UIImage?, size: CGSize?) -> UIImage? {
        if let size = size {
            UIGraphicsBeginImageContext(size)
            image?.draw(in: CGRectMake(0, 0, size.width, size.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }

    func getBase64String() -> String? {
        if let signature = self.signatureView, let image = signature.screenShot, signature.reset == false {
            return image.convertImageToBase64()
        }
        return nil
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        let imgString = getBase64String()
        navigationController?.popViewController(animated: true)
        callBack?(imgString)
    }
    
}

