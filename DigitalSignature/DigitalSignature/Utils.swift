//
//  Utils.swift
//  SignatureApp
//
//  Created by asma.bee on 03/10/2024.
//

import UIKit

extension UIImage {
    func convertBase64ToImage(_ str: String) -> UIImage {
        if let dataDecoded = Data(base64Encoded: str, options: .ignoreUnknownCharacters),
            let decodedimage = UIImage(data: dataDecoded) {
            return decodedimage
        }
        return UIImage()
    }
    
    func convertImageToBase64() -> String {
        let imageData = pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}
