import UIKit

class ProteinViewController: UIViewController {
    var protein: Protein = Protein()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var ligand: String = String()
        
        if let _ : [String] = protein.ligand{
            ligand = "have"
        }else {
            ligand = "nil"
        }

        print(protein.ligand)
        
        self.showAlertWith(title: protein.name + " ligand: " + ligand)
        
    }
}
