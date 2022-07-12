//
//  CustomTableHeader.swift
//  DVTWeatherApp
//
//  Created by Daniel Nzuma on 11/07/2022.
//

import Foundation
import UIKit
import networkingCore

class FavItemCell: UITableViewCell {
    
    private var mStackView   = UIStackView()
    
    let cityLblVal: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 14.0)
        lbl.numberOfLines = 1
        lbl.textColor = .black
 
        return lbl
    }()
    
    let cityLblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 14.0)
        lbl.numberOfLines = 1
        lbl.textColor = .black
        lbl.text = "Country :"
 
        return lbl
    }()
    
    let locationLblVal: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 14.0)
        lbl.numberOfLines = 1
        lbl.textColor = .black
 
        return lbl
    }()
    
    
    let locationLblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 14.0)
        lbl.numberOfLines = 1
        lbl.textColor = .black
        lbl.text = "Location :"
 
        return lbl
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureContents()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func configureContents() {
        let mCountryStack = UIStackView(arrangedSubviews: [
            cityLblTitle,cityLblVal
        ])
        mCountryStack.axis = .horizontal
        mCountryStack.translatesAutoresizingMaskIntoConstraints = false
        mCountryStack.distribution = .fillEqually
        mCountryStack.spacing = 12
 
        
        let mLocationStack = UIStackView(arrangedSubviews: [
            locationLblTitle,locationLblVal
        ])
        mLocationStack.axis = .horizontal
        mLocationStack.translatesAutoresizingMaskIntoConstraints = false
        mLocationStack.distribution = .fillEqually
        mLocationStack.spacing = 12

        
        
        mStackView = UIStackView(arrangedSubviews: [
            mCountryStack,
            mLocationStack
        ])
        
        mStackView.axis = .vertical
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        mStackView.alignment = .fill
        
        contentView.addSubview(mStackView)
        
        mStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        mStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7).isActive = true


    }
    
   
}
