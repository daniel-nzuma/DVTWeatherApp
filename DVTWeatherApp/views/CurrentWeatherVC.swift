//
//  ViewController.swift
//  Weather app
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import UIKit
import networkingCore
import CoreLocation
import CoreData


class CurrentWeatherVC: UIViewController, CLLocationManagerDelegate {
    
    var mWeatherForecastItemList = [WeatherForecastItem]()
    fileprivate let child = SpinnerViewController()
    fileprivate var mTemperatureInfoStackView   = UIStackView()
    var userLocation = CLLocation()
    private var minTempVal:String  = ""
    fileprivate var mCity = ""
    fileprivate var mCountry = ""
    private var maxTempVal:String  = ""
    private var currentTempVal:String  = ""
    var locationManager:CLLocationManager!
    fileprivate var favItem = FavouriteWeatherItem(country: "",city: "",lat: "",long: "")


    let bgImage : UIImageView = {
         
        let imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        
        return imageV
        }()
    
    let currentTempLablMain: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 31.0)
        lbl.numberOfLines = 0
        lbl.textColor = .white
        lbl.textAlignment = .center

        return lbl
    }()
    
    let viewFavouritesLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 14.0)
        lbl.numberOfLines = 0
        lbl.textColor = .white
        lbl.text = "View Favourites"
        lbl.textAlignment = .center

        return lbl
    }()
    
    let addToFavouritesIM: UIImageView = {
        let im = UIImageView()
        im.translatesAutoresizingMaskIntoConstraints = false
        im.image = UIImage(named: "favourite")
        return im
    }()
    
    let tableView = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        self.setupLocation()

    }
    
    fileprivate func setupLocation()
    {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()

            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        if let location = locations.last {
            userLocation = location as CLLocation
            self.getCurrentWeather()
            self.getWeatherForecast()
            
         }


        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0{
                let placemark = placemarks![0]
                self.mCountry = placemark.country!
             }
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    fileprivate func prepareCurrentTemperatureLabel(tempVal:String)
    {
        currentTempLablMain.text = tempVal
        view.addSubview(currentTempLablMain)

        NSLayoutConstraint.activate([
            currentTempLablMain.centerXAnchor.constraint(equalTo: bgImage.centerXAnchor),
            currentTempLablMain.centerYAnchor.constraint(equalTo: bgImage.centerYAnchor),
           ])
         
    }
    
    fileprivate func updateBgAndColorOnWeatherChange(_ mCuurrentWeather:String)
    {
        if(mCuurrentWeather.lowercased().contains("sun"))
        {
            bgImage.image = UIImage(named:"forest_sunny.png")
            tableView.backgroundColor = colorFromWeather("sun")

        }
        else if(mCuurrentWeather.lowercased().contains("rain"))
        {
            bgImage.image = UIImage(named:"forest_rainy.png")
            tableView.backgroundColor = colorFromWeather("rain")


        }
        else if(mCuurrentWeather.lowercased().contains("cloud"))
        {
            bgImage.image = UIImage(named:"forest_cloudy.png")
            tableView.backgroundColor = colorFromWeather("cloud")

        }
        else if(mCuurrentWeather.lowercased().contains("clear"))
        {
            bgImage.image = UIImage(named:"forest_cloudy.png")
            tableView.backgroundColor = colorFromWeather("clear")

        }
         
    }
    
    fileprivate func prepareAddWeatherToFavouriteView()
    {
        addToFavouritesIM.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addToFavouritesIM.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(addToFavWeather))
        addToFavouritesIM.isUserInteractionEnabled = true
        addToFavouritesIM.addGestureRecognizer(singleTap)
        
        let singleTapLbl = UITapGestureRecognizer(target: self, action: #selector(navigateToFavouritesListVC))
        viewFavouritesLbl.isUserInteractionEnabled = true
        viewFavouritesLbl.addGestureRecognizer(singleTapLbl)

        var mStackView = UIStackView(arrangedSubviews: [
            UIView(),
            viewFavouritesLbl,
            UIView(),
            UIView(),
            addToFavouritesIM,
            UIView()

        ])
        
        mStackView.axis = .horizontal
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        mStackView.distribution = .equalCentering
        
        
 
        view.addSubview(mStackView)
        
        NSLayoutConstraint.activate([
            mStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
        ])
        
         mStackView.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        
        
        if #available(iOS 11, *) {
          let guide = view.safeAreaLayoutGuide
          NSLayoutConstraint.activate([
            mStackView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
           ])
        } else {
           let standardSpacing: CGFloat = 8.0
           NSLayoutConstraint.activate([
            mStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
           ])
        }

    }
    
    func saveFavWeatherLocation()
    {
        let mLat = userLocation.coordinate.latitude.description
        let mLong = userLocation.coordinate.longitude.description
        
        favItem = FavouriteWeatherItem(country: mCountry,city:mCity,lat:mLat ,long: mLong)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "FavouriteWeather", in: managedContext)!
            
         let item = NSManagedObject(entity: userEntity, insertInto: managedContext)
         item.setValue( favItem.country!,forKeyPath: "country")
         item.setValue( favItem.city!,forKeyPath: "city")
         item.setValue( favItem.lat!,forKeyPath: "lat")
         item.setValue( favItem.long!,forKeyPath: "long")

        do {
            try managedContext.save()
           
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @objc func addToFavWeather() {
        
        addToFavouritesIM.alpha = 0.75
        UIView.animate(withDuration: 0.5) {
            self.addToFavouritesIM.alpha = 1.0
           }
             
        let refreshAlert = UIAlertController(title: "Info", message: "Add the current weather location to favourites", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.saveFavWeatherLocation()
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                refreshAlert.dismiss(animated: true)
            }))

            present(refreshAlert, animated: true, completion: nil)
        
    }
    
    @objc func navigateToFavouritesListVC() {
        let mFavouritesListVC = FavouritesListVC()
        self.present(mFavouritesListVC, animated: false, completion: nil)
    }
    
    
    fileprivate func colorFromWeather(_ mWeather:String) -> UIColor
    {
        var color = UIColor.clear
        if(mWeather.lowercased().contains("sun"))
        {
            color = .sunny

        }
        else if(mWeather.lowercased().contains("rain"))
        {
            color = .rainny

        }
        else if(mWeather.lowercased().contains("cloud"))
        {
            color = .cloudy

        }
        else if(mWeather.lowercased().contains("clear"))
        {
            color = .gray

        }
        return color
    }
    
    fileprivate func prepareWeatherImageView()
    {
        view.addSubview(bgImage)

        bgImage.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        bgImage.heightAnchor.constraint(equalTo:view.heightAnchor,multiplier: 0.5).isActive = true
        bgImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    fileprivate func prepareTableView()
    {
        tableView.register(CustomTableHeader.self,
        forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderTopPadding = 3
        
        tableView.register(WeatherCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
        
        tableView.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: bgImage.bottomAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo:view.heightAnchor,multiplier: 0.5).isActive = true

        
           
    }
    
    fileprivate func formatTemperatureValue(mTemperatureValue:String,mTemperatureLbl:String) -> String
    {
        let formatTemp = NSString(format:"\(mTemperatureValue)%@" as NSString, "\u{00B0}") as String
        let currentTempVal = "\(formatTemp)\n\(mTemperatureLbl)"
        
        return currentTempVal
    }

    fileprivate func showLoader(isVisible:Bool)
    {
        if(isVisible)
        {
            addChild(child)
            child.view.frame = view.frame
            view.addSubview(child.view)
            child.didMove(toParent: self)
            
        }
        else
        {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
       
        

    }
 

}

extension CurrentWeatherVC {
    
    @objc func getCurrentWeather(){
       
       showLoader(isVisible: true)
        
        let req = GetWeatherRequest()
        req.longitude = userLocation.coordinate.longitude.description
        req.latitude = userLocation.coordinate.latitude.description
        
        RequestManager.AuthInstance.getCurrentWeather(mGetCurrenWeatherReq: req) { (status,currentTemp,minTemp,maxTemp,msg,city) in
            //
            DispatchQueue.main.async {[weak weakSelf = self] in
                
                self.showLoader(isVisible: false)

                if(status != 0)
                {
                    let weather = msg!
                    let formatTemp = NSString(format:"\(currentTemp!)%@" as NSString, "\u{00B0}") as String
                    let tempLocalised = "\(formatTemp)\n\(weather)"

                    self.prepareWeatherImageView()
                    self.prepareCurrentTemperatureLabel(tempVal: tempLocalised)
                    self.prepareTableView()
                    self.prepareAddWeatherToFavouriteView()
                    
                    self.maxTempVal = maxTemp!
                    self.minTempVal = minTemp!
                    self.currentTempVal = currentTemp!
                    
                    self.updateBgAndColorOnWeatherChange(weather)
                    self.mCity = city
                    

                    
                }

                   
                    
            }
        }
    }
    
    @objc func getWeatherForecast(){
       
       showLoader(isVisible: true)
        
        let req = GetWeatherRequest()
        req.longitude =  userLocation.coordinate.longitude.description
        req.latitude =  userLocation.coordinate.latitude.description
        
        RequestManager.AuthInstance.getWeatherForecast(mGetCurrenWeatherReq: req) { (status,data,msg) in
            //
            DispatchQueue.main.async {[weak weakSelf = self] in
                
                weakSelf!.showLoader(isVisible: false)

                if(status != 0)
                {
                    if(data != nil)
                    {
                        self.mWeatherForecastItemList = data!
                        self.tableView.reloadData()

                    }

                }

                    
            }
        }
    }
}

extension CurrentWeatherVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
      
    func tableView(_ tableView: UITableView,
            viewForHeaderInSection section: Int) -> UIView? {
       
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                   "sectionHeader") as! CustomTableHeader
        
        let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: view.frame.height, width: self.view.frame.maxX, height: 2))
   
        view.currentTempLablSub.text = formatTemperatureValue(mTemperatureValue: currentTempVal, mTemperatureLbl:"current".localizedLowercase)
        view.maxTempLablSub.text = formatTemperatureValue(mTemperatureValue: maxTempVal, mTemperatureLbl:"max")
        view.minTempLablSub.text = formatTemperatureValue(mTemperatureValue: minTempVal, mTemperatureLbl:"min")
        
        separatorView.backgroundColor = UIColor.separatorColor
        view.contentView.backgroundColor = colorFromWeather(currentTempLablMain.text!)
        
        view.addSubview(separatorView)

       return view
    }
    
         
}

extension UIColor {
   class var separatorColor: UIColor {
     return UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
   }
}

extension CurrentWeatherVC:UITableViewDataSource{
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return mWeatherForecastItemList.count
      }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         
        if(currentTempLablMain.text!.lowercased().contains("sun"))
        {
            bgImage.image = UIImage(named:"forest_sunny.png")
            cell.contentView.backgroundColor = .sunny

        }
        else if(currentTempLablMain.text!.lowercased().contains("rain"))
        {
            bgImage.image = UIImage(named:"forest_rainy.png")
            cell.contentView.backgroundColor = .rainny


        }
        else if(currentTempLablMain.text!.lowercased().contains("cloud"))
        {
            bgImage.image = UIImage(named:"forest_cloudy.png")
            cell.contentView.backgroundColor = .cloudy

        }
        else if(currentTempLablMain.text!.lowercased().contains("clear"))
        {
            bgImage.image = UIImage(named:"forest_cloudy.png")
            cell.contentView.backgroundColor = .gray

        }

        
    }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherCell
        cell.mWeatherForecastItem = mWeatherForecastItemList[indexPath.row]
        
        return cell
      }
    

}
