import SceneKit

class SetupScene: SCNScene{
    
    //MARK: - Public properties
    var atoms: [SCNNode] = []
    
    //MARK: - Private properties
    private var changeAtom = Bool()
    private var manageLines = Bool()
    
    //MARK: - Initialization
    init(_ data: [String], _ changeAtom: Bool, _ manageLines: Bool) {
        
        super.init()
        
        self.changeAtom = changeAtom
        self.manageLines = manageLines
        self.sceneConfiguration(data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func sceneConfiguration(_ data: [String]){
        if !changeAtom{
            let sphereGeometry = SCNSphere(radius: 0.3)
            let sphereNode = SCNNode(geometry: sphereGeometry)
            self.atoms.append(sphereNode)
        }else {
            let boxGeometry = SCNBox(width: 0.7, height: 0.7, length: 0.7, chamferRadius: 1)
            let boxNode = SCNNode(geometry: boxGeometry)
            self.atoms.append(boxNode)
        }
        
        for item in data {
            var itemStruct: [String] = item.components(separatedBy: " ")
            itemStruct = itemStruct.filter({(item) -> Bool in item != ""})
            guard itemStruct.count > 0
                && (itemStruct[ModelsKeys.keyType] == ModelsKeys.keyAtom
                    || itemStruct[ModelsKeys.keyType] == ModelsKeys.keyConect) else { return }
            
            if itemStruct[ModelsKeys.keyType] == ModelsKeys.keyAtom && !changeAtom{
                self.atoms.append(self.getAtomSphere(itemStruct))
            }
            
            if itemStruct[ModelsKeys.keyType] == ModelsKeys.keyAtom && changeAtom{
                self.atoms.append(self.getAtomSquer(itemStruct))
            }
            
            if itemStruct[ModelsKeys.keyType] == ModelsKeys.keyConect
                && !self.manageLines{
                self.getConnect(itemStruct)
            }
        }
        
    }
    
    private func getAtomSphere(_ item: [String]) -> SCNNode{
        
        let newSphereGeometry: SCNSphere = SCNSphere(radius: 0.35)
        newSphereGeometry.firstMaterial?.diffuse.contents = self.getColor(item[ModelsKeys.keyElementSymbol])
        newSphereGeometry.firstMaterial?.specular.contents = self.getColor(item[ModelsKeys.keyElementSymbol])
        let newSphereNode: SCNNode = SCNNode(geometry: newSphereGeometry)
        
        newSphereNode.position = SCNVector3(
            Float(item[ModelsKeys.keyPointX]) ?? 0.0,
            Float(item[ModelsKeys.keyPointY]) ?? 0.0,
            Float(item[ModelsKeys.keyPointZ]) ?? 0.0
        )
        newSphereNode.name = item[ModelsKeys.keyElementSymbol]
        self.rootNode.addChildNode(newSphereNode)
        
        return newSphereNode
    }
    
    private func getAtomSquer(_ item: [String]) -> SCNNode{
        
        let newBoxGeometry: SCNBox = SCNBox(width: 0.7, height: 0.7, length: 0.7, chamferRadius: 0.0)
        newBoxGeometry.firstMaterial?.diffuse.contents = self.getColor(item[ModelsKeys.keyElementSymbol])
        newBoxGeometry.firstMaterial?.specular.contents = self.getColor(item[ModelsKeys.keyElementSymbol])
        let newBoxNode: SCNNode = SCNNode(geometry: newBoxGeometry)
        
        newBoxNode.position = SCNVector3(
            Float(item[ModelsKeys.keyPointX]) ?? 0.0,
            Float(item[ModelsKeys.keyPointY]) ?? 0.0,
            Float(item[ModelsKeys.keyPointZ]) ?? 0.0
        )
        newBoxNode.name = item[ModelsKeys.keyElementSymbol]
        self.rootNode.addChildNode(newBoxNode)
        
        return newBoxNode
    }
    
    private func getConnect(_ item: [String]){
        guard let number: Int = Int( item[ModelsKeys.keyAtomNumber]) else { return }
        
        let startPoint: Int = number
        let lastPointCount: Int = item.count
        let allConects: ArraySlice<String> = item[2..<lastPointCount]
        
        for element in allConects{
            guard let endPoint: Int = Int(element) else { return }
            
            let conect = SCNNode()
            self.rootNode.addChildNode(conect.connectBetweenTwoNodes(from: atoms[startPoint], to: atoms[endPoint]))
        
        }
        
        
    }
    
    private func getColor(_ atom: String) -> UIColor{
        var color = UIColor()
        
        switch atom {
        case "H":
            color = UIColor.white
        case "C":
            color = UIColor.black
        case "N":
            color = UIColor(red:0.00, green:0.14, blue:0.49, alpha:1.0)
        case "O":
            color = UIColor.red
        case "F", "Cl":
            color = UIColor.green
        case "Br":
            color = UIColor(red:0.49, green:0.00, blue:0.00, alpha:1.0)
        case "I":
            color = UIColor(red:0.37, green:0.00, blue:0.49, alpha:1.0)
        case "He", "Ne", "Ar", "Xe", "Kr":
            color = UIColor(red:0.22, green:0.94, blue:0.99, alpha:1.0)
        case "P":
            color = UIColor.orange
        case "S":
            color = UIColor.yellow
        case "B":
            color = UIColor(red:0.99, green:0.73, blue:0.51, alpha:1.0)
        case "Li", "Na", "K", "Rb", "Cs", "Fr":
            color = UIColor.purple
        case "Be", "Mg", "Ca", "Sr", "Ba", "Ra":
            color = UIColor(red:0.05, green:0.33, blue:0.02, alpha:1.0)
        case "Ti":
            color = UIColor.gray
        case "Fe":
            color = UIColor.orange
        default:
            color = UIColor(red:1.00, green:0.00, blue:0.60, alpha:1.0)
        }
        return color
    }
}
