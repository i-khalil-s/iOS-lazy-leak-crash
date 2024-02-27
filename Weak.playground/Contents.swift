import UIKit

protocol CarStateDelegate: AnyObject {
    func didStartMoving()
    func didStopMoving()
}

final class Car {
    // Optional delegate to assign
    var delegate: CarStateDelegate? // <- Retain cycle
    
    init() {}
    
    func turnOn() { delegate?.didStartMoving() }
    
    // Turn off your car before releasing it!
    func turnOff() {
        // Possible UI updates had to be on the main thread
        DispatchQueue.main.async {
            // Retain cycle
            self.delegate?.didStopMoving()
        }
    }
}

final class Garage {
    lazy var myCar: Car = {
        let car = Car()
        car.delegate = self
        return car
    }()
    
    init() {}
    
    func siriPrepareGarage() {
        myCar.turnOn()
    }
    
    deinit {
        // Ensure `car` terminates all its operations after removing garage to avoid leaks
        myCar.turnOff()
    }
}

extension Garage: CarStateDelegate {
    func didStartMoving() { /* Turn lights on */ }
    
    func didStopMoving() { /* Close door and turn lights off */ }
}

var myGarage: Garage? = Garage()
// Calling lazy var `Car` on the deinit! Which sets a string reference to self.
//myGarage?.siriPrepareGarage()
myGarage = nil // Sets garage to nil
// This object's deinit, or something called from it, may have created a strong reference to self which outlived deinit, resulting in a dangling reference.
myGarage?.myCar == nil // Car is now nil
