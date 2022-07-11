//
//  FavouritesListVC.swift
//  DVTWeatherApp
//
//  Created by Daniel Nzuma on 11/07/2022.
//

import Foundation
import UIKit
import CoreData

class FavouritesListVC: UIViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        retrieveData()
        
    }
    
    func retrieveData() {
            
             guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
             let managedContext = appDelegate.persistentContainer.viewContext
            
             let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteWeather")
             
            do {
                let result = try managedContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    // print(data.value(forKey: "city") as! String)

                }
                
            } catch {
                
                print("Failed")
            }
    }
}
