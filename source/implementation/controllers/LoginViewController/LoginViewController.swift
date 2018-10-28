import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    //MARK: - Public properties
    var сontext = LAContext()
    
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: ModelsKeys.keyBackGroud)!)
        
        if !self.сontext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
            
            if let loginButton: UIButton = self.login {
                loginButton.isHidden = true
                self.infoLabel.text = "Sorry, but only users \nwith touchID can log in!"
            }
        } else {
            self.infoLabel.text = "Please, press \nthe button to log in!"
        }
        
        CurrentViewContoller.shared.currentViewController = self
    }
    
    //MARK: - IBAction
    
    @IBAction func loginButtonClicked(_ sender:  UIButton){
        
        var error: NSError?
        
        self.сontext = LAContext()
        self.сontext.localizedCancelTitle = "Cancel"

        if self.сontext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            
            let reason = "Log in"
            self.сontext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
                
                if success {
                    DispatchQueue.main.async {
                        let _ = ProteinDataModel.getProteins()
                        self.performSegue(withIdentifier: ProteinListViewController.className(), sender: nil)
                    }
                } else {
                    print(1)
                    print(error?.localizedDescription ?? "Failed to auth")
                }
            }
        }
    }
}
