//
//  extensions.swift
//  DVTWeatherApp
//
//  Created by Daniel Nzuma on 10/07/2022.
//

import Foundation
import UIKit

extension UIView {
 
 func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
 var topInset = CGFloat(0)
 var bottomInset = CGFloat(0)
 
 if #available(iOS 11, *), enableInsets {
 let insets = self.safeAreaInsets
 topInset = insets.top
 bottomInset = insets.bottom
 
 print("Top: \(topInset)")
 print("bottom: \(bottomInset)")
 }
 
 translatesAutoresizingMaskIntoConstraints = false
 
 if let top = top {
 self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
 }
 if let left = left {
 self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
 }
 if let right = right {
 rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
 }
 if let bottom = bottom {
 bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
 }
 if height != 0 {
 heightAnchor.constraint(equalToConstant: height).isActive = true
 }
 if width != 0 {
 widthAnchor.constraint(equalToConstant: width).isActive = true
 }
 
 }
 
}




extension String {
    func localized(_ data:[String:String])-> String {
        
        if  UserDefaults.standard.string(forKey: "i18n_language") == nil {
            UserDefaults.standard.set("en", forKey: "i18n_language")
            UserDefaults.standard.synchronize()
        }
 
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        if  let bundle = Bundle(path: path!){
           var trString = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
           
            data.forEach { key, value in
                trString = trString.replacingOccurrences(of: key, with: value)
            }
            return trString
        }else{
            return self
        }
        
    }
    
    
}

extension UIColor {
    
    static var sunny: UIColor {
        return hexStringToUIColor("#47AB2F")
    }
    
    static var cloudy: UIColor {
        return hexStringToUIColor("#54717A")
    }
    
    static var rainny: UIColor {
        return hexStringToUIColor("#57575D")
    }
}

func hexStringToUIColor (_ hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
