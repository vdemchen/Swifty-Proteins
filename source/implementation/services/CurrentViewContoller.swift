import UIKit

class CurrentViewContoller: NSObject {
    
    static let shared = CurrentViewContoller()
    
    var currentViewController: UIViewController?
}
