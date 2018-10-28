import UIKit
import SceneKit

class ProteinViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var sceneView: SCNView!
    
    // MARK: - Public Properies
    var protein: Protein = Protein()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sceneSetup()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        sceneView.stop(nil)
        sceneView.play(nil)
    }
    
    // MARK: - Scene
    
    func sceneSetup(){
        guard let data: [String] = protein.ligand else { return }
        
        let scene = SetupScene(data)
        
        self.sceneView.allowsCameraControl = true
        self.sceneView.backgroundColor = UIColor.gray
        
        self.sceneView.scene = scene
    }
}
