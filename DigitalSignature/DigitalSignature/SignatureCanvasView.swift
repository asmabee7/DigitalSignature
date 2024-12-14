//
//  SignatureCanvasView.swift
//  PaperlessJourney
//
//  Created by asma.bee on 20/06/2023.
//  Copyright © 2023 Mobile DevOps. All rights reserved.
//

import Foundation
import UIKit

class SignatureCanvasView: UIImageView {
    private lazy var path = UIBezierPath()
    private lazy var previousTouchPoint = CGPoint.zero
    private lazy var shapeLayer = CAShapeLayer()
    var reset = false
    var callBack: ((Bool?) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView(){
        layer.addSublayer(shapeLayer)
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.black.cgColor
        isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        reset = false
        if let location = touches.first?.location(in: self) { previousTouchPoint = location }
        callBack?(true)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        reset = false
        if let location = touches.first?.location(in: self), self.bounds.contains(location) {
            path.move(to: location)
            path.addLine(to: previousTouchPoint)
            previousTouchPoint = location
            shapeLayer.path = path.cgPath
        }
        callBack?(true)
    }

    func clear() {
        self.path = UIBezierPath()
        shapeLayer.path = path.cgPath
        self.image = nil
        reset = true
    }
}

extension UIView {
    var screenShot: UIImage?  {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return screenshot
        }
        return nil
    }
}
