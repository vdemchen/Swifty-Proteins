import UIKit
import SceneKit

class ProteinViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var changeAtomView: UIButton!
    @IBOutlet weak var offLineBetweenAtoms: UIButton!
    
    // MARK: - Public Properies
    var protein: Protein = Protein()
    
    // MARK: - Private Properies
    private var changeAtom: Bool = false
    private var manageLines: Bool = false
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sceneSetup()
        setButtons()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        sceneView.stop(nil)
        sceneView.play(nil)
    }
    
    // MARK: - IBAction
    
    @IBAction func changeAtom(_ sender: Any){
        self.changeAtom = !self.changeAtom
        self.viewDidAppear(true)
    }
    
    @IBAction func changeLines(_ sender: Any){
        self.manageLines = !self.manageLines
        self.viewDidAppear(true)
        
    }
    
    // MARK: - Private methods
    private func setButtons() {
        if !changeAtom{
            self.changeAtomView.setTitle("To squrs", for: .normal)
        } else {
            self.changeAtomView.setTitle("To sphere", for: .normal)
        }
        
        if !manageLines{
            self.offLineBetweenAtoms.setTitle("Hide lines", for: .normal)
        } else {
            self.offLineBetweenAtoms.setTitle("Show lines", for: .normal)
        }
    }
    
    // MARK: - Scene
    func sceneSetup(){
        guard let data: [String] = protein.ligand else { return }
        
        let scene = SetupScene(data, changeAtom, manageLines)
        
        self.sceneView.allowsCameraControl = true
        self.sceneView.backgroundColor = UIColor.gray
        
        self.sceneView.scene = scene
    }
}
