//
//  CustomTableHeader.swift
//  DVTWeatherApp
//
//  Created by Daniel Nzuma on 11/07/2022.
//

import Foundation
import UIKit

class CustomTableHeader: UITableViewHeaderFooterView {
    
    var mTemperatureInfoStackView   = UIStackView()

    
    let currentTempLablSub: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 16.0)
        lbl.numberOfLines = 0
        lbl.textColor = .white
        lbl.textAlignment = .center

        return lbl
    }()
    
    let maxTempLablSub: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 16.0)
        lbl.numberOfLines = 0
        lbl.textColor = .white
        lbl.textAlignment = .center

        return lbl
    }()
    
    
    let minTempLablSub: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 16.0)
        lbl.numberOfLines = 0
        lbl.textColor = .white
        lbl.textAlignment = .center

        return lbl
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func configureContents() {
        
        mTemperatureInfoStackView = UIStackView(arrangedSubviews: [
            UIView(),
            UIView(),
            UIView(),
            minTempLablSub,
            UIView(),
            UIView(),
            UIView(),
            currentTempLablSub,
            UIView(),
            UIView(),
            UIView(),
            maxTempLablSub
        ])
        mTemperatureInfoStackView.axis = .horizontal
        mTemperatureInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        mTemperatureInfoStackView.alignment = .fill
        mTemperatureInfoStackView.spacing = 16
        
        contentView.addSubview(mTemperatureInfoStackView)
        contentView.backgroundColor = .green

    }
    
    
    fileprivate func formatTemperatureValue(mTemperatureValue:String,mTemperatureLbl:String) -> String
    {
        let formatTemp = NSString(format:"\(mTemperatureValue)%@" as NSString, "\u{00B0}") as String
        let currentTempVal = "\(formatTemp)\n\(mTemperatureLbl)"
        
        return currentTempVal
    }
}
