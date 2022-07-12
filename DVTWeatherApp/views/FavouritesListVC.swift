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
import MapKit
 
class FavouritesListVC :UITableViewController, NSFetchedResultsControllerDelegate, MKMapViewDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<WeatherItemController>!
    let favListtableView = UITableView()
    let mapView  = MKMapView()
    let annotation = MKPointAnnotation()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
        prepareMapView()
         initializeFetchedResultsController()
    }
    
    fileprivate func addMarker(lat:String,long:String,city:String)
    {
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude:Double(long)!)
        annotation.title = city
        mapView.addAnnotation(annotation)
        
     }
    
    fileprivate func prepareMapView()
    {
        mapView.translatesAutoresizingMaskIntoConstraints = false

        mapView.frame = view.frame
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
         
        
        view.addSubview(mapView)

        mapView.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo:favListtableView.bottomAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo:view.heightAnchor,multiplier: 0.6).isActive = true
        

    }
    
    fileprivate func prepareTableView()
    {
        
        favListtableView.translatesAutoresizingMaskIntoConstraints = false
        favListtableView.separatorStyle = .none
        favListtableView.delegate = self
        favListtableView.dataSource = self
         favListtableView.rowHeight = UITableView.automaticDimension
        favListtableView.sectionHeaderTopPadding = 3
        favListtableView.separatorColor = .brown
        favListtableView.separatorStyle = .singleLine
        
        favListtableView.register(FavItemCell.self, forCellReuseIdentifier: "favCell")
        
        view.addSubview(favListtableView)

        favListtableView.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        favListtableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        favListtableView.heightAnchor.constraint(equalTo:view.heightAnchor,multiplier: 0.5).isActive = true

    }
    
    private func initializeFetchedResultsController() {
        
        let request = NSFetchRequest<WeatherItemController>(entityName: "FavouriteWeather")
        let countrySort = NSSortDescriptor(key: "country", ascending: false)
        request.sortDescriptors = [countrySort]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let MOC = appDelegate.persistentContainer.viewContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: MOC, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to initialize FetchedResultsController: \(error)")
        }
    }

     
     
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let n = fetchedResultsController?.sections!.count {
            return n
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let cell = tableView.cellForRow(at: indexPath) as! FavItemCell
        let city = cell.cityLblVal.text
        let latlong = cell.locationLblVal.text?.split(separator: ",")
        let lat = latlong![0]
        let long = latlong![1]
        self.addMarker(lat: lat.description, long: long.description, city: city!)
 
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        let n =  sectionInfo.numberOfObjects
        return n
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = favListtableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)  as! FavItemCell
        let object = fetchedResultsController.object(at: indexPath)
        
        let country = object.value(forKeyPath: "country") as? String
        let city = object.value(forKeyPath: "city") as? String

        let lat = object.value(forKeyPath: "lat") as? String
        let long = object.value(forKeyPath: "long") as? String

        cell.locationLblVal.text = "\(lat!),\(long!)"
        cell.locationLblVal.textColor = .black
        
        cell.cityLblVal.text = "\(country!) (\(city!))"
        cell.cityLblVal.textColor = .black
        
        
        return cell
    }
    
    
 
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        favListtableView.beginUpdates()
    }


    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        favListtableView.endUpdates()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
            
        }
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)

        
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        return annotationView
    }
    
     
}
