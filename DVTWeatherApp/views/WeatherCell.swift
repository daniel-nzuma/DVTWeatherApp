//
//  CustomTableHeader.swift
//  DVTWeatherApp
//
//  Created by Daniel Nzuma on 11/07/2022.
//

import Foundation
import UIKit
import networkingCore

class WeatherCell: UITableViewCell {
    
    private var mStackView   = UIStackView()

    func getDayOfWeek(_ date:String) -> String? {
        
        let weekDays = [
            "Sun",
            "Mon",
            "Tue",
            "Wed",
            "Thu",
            "Fri",
            "Sat"
        ]
        
        let dateWithoutTimestamp = date.split(separator: " ")
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let myDate = formatter.date(from: dateWithoutTimestamp[0].description) else { return nil }
        
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: myDate)
        return weekDays[weekDay-1]
    }
    
    
    var mWeatherForecastItem : WeatherForecastItem? {
     didSet {
         dayOfWeekLbl.text = getDayOfWeek((mWeatherForecastItem?.timestmp!)!)
         tempIconImView.image = imageByWeatherType((mWeatherForecastItem?.mWeatherDesc?[0].weatherName)!)
         temperatureLabl.text = mWeatherForecastItem?.mainWeather?.currentTemperature?.description
     }
     }
     
    private func imageByWeatherType(_ mWeatherName:String) -> UIImage
    {
        var image = "clear.png"
        if(mWeatherName.lowercased().contains("rain"))
        {
            image = "rainy.png"
        }
        else if(mWeatherName.lowercased().contains("sun"))
        {
            image = "sunny.png"
        }
        else if(mWeatherName.lowercased().contains("clear"))
        {
            image = "clear.png"
        }
        
        return UIImage(named: image)!
    }
    
    let dayOfWeekLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 14.0)
        lbl.numberOfLines = 1
        lbl.textColor = .white
 
        return lbl
    }()
    
    let tempIconImView: UIImageView = {
        var im = UIImageView()
        im  = UIImageView(frame:CGRect(x:10, y:50, width:25, height:25));

        return im
    }()
    
    
    let temperatureLabl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 14.0)
        lbl.numberOfLines = 1
        lbl.textColor = .white
        lbl.textAlignment = .right
 
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
        
        mStackView = UIStackView(arrangedSubviews: [
            UIView(),
            UIView(),
            UIView(),
            dayOfWeekLbl,
            UIView(),
            UIView(),
            UIView(),
            UIView(),
            UIView(),
            UIView(),
            tempIconImView,
            UIView(),
            UIView(),
            UIView(),
            UIView(),
            temperatureLabl,
            UIView(),
            UIView()

        ])
        mStackView.axis = .horizontal
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        mStackView.alignment = .fill
        mStackView.spacing = 16
        
        contentView.addSubview(mStackView)

    }
    
   
}
