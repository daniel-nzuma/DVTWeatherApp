import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    private var locationManager = CLLocationManager()
    private let operationQueue = OperationQueue()

    override init(){
        super.init()

        //Pause the operation queue because
        // we don't know if we have location permissions yet
        operationQueue.isSuspended = true
        locationManager.delegate = self
    }

    ///When the user presses the allow/don't allow buttons on the popup dialogue
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        //If we're authorized to use location services, run all operations in the queue
        // otherwise if we were denied access, cancel the operations
        if(status == .authorizedAlways || status == .authorizedWhenInUse){
            self.operationQueue.isSuspended = false
        }else if(status == .denied){
            self.operationQueue.cancelAllOperations()
        }
    }

    ///Checks the status of the location permission
    /// and adds the callback block to the queue to run when finished checking
    /// NOTE: Anything done in the UI should be enclosed in `DispatchQueue.main.async {}`
    func runLocationBlock(callback: @escaping () -> ()){

        //Get the current authorization status
        let authState = CLLocationManager.authorizationStatus()

        //If we have permissions, start executing the commands immediately
        // otherwise request permission
        if(authState == .authorizedAlways || authState == .authorizedWhenInUse){
            self.operationQueue.isSuspended = false
        }else{
            //Request permission
            locationManager.requestAlwaysAuthorization()
        }

        //Create a closure with the callback function so we can add it to the operationQueue
        let block = { callback() }

        //Add block to the queue to be executed asynchronously
        self.operationQueue.addOperation(block)
    }
}
