import SceneKit

class SetupScene: SCNScene {
    
    //MARK: - Public properties
    let scene = SCNScene()
    var atoms: [SCNNode] = []
    
    
    //MARK: - Initialization
    init(_ data: [String]) {
        super.init()
        self.sceneConfiguration(data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    func getScene() -> SCNScene { return self.scene }
    
    //MARK: - Private methods
    private func sceneConfiguration(_ data: [String]){
        let sphereGeometry = SCNSphere(radius: 0.5)
        let sphereNode = SCNNode(geometry: sphereGeometry)
        self.atoms.append(sphereNode)
        
        for item in data {
            var itemStruct: [String] = item.components(separatedBy: " ")
            itemStruct = itemStruct.filter({(item) -> Bool in item != ""})
            guard itemStruct.count > 0 else { return }
            if itemStruct[ModelsKeys.keyType] == ModelsKeys.keyAtom{
                self.atoms.append(self.getAtom(itemStruct))
            }
            if itemStruct[ModelsKeys.keyType] == ModelsKeys.keyConect{
                self.getConnect(itemStruct)
            }
 
        }
        
    }
    
    private func getAtom(_ item: [String]) -> SCNNode{
        
        let newSphereGeometry: SCNSphere = SCNSphere(radius: 0.3)
        let newSphereNode: SCNNode = SCNNode(geometry: newSphereGeometry)
        
        newSphereNode.position = SCNVector3(
            Float(item[ModelsKeys.keyPointX]) ?? 0.0,
            Float(item[ModelsKeys.keyPointY]) ?? 0.0,
            Float(item[ModelsKeys.keyPointZ]) ?? 0.0
        )
        newSphereNode.name = item[ModelsKeys.keyElementSymbol]
        newSphereNode.light?.color = self.getColor(item[ModelsKeys.keyElementSymbol])
        
        self.rootNode.addChildNode(newSphereNode)
        
        return newSphereNode
    }
    
    private func getConnect(_ item: [String]){
        guard let number: Int = Int( item[ModelsKeys.keyAtomNumber]) else { return }
        
        let startPoint: Int = number
        let lastPointCount: Int = item.count
        let allConects: ArraySlice<String> = item[2..<lastPointCount]
        
        for element in allConects{
            guard let endPoint: Int = Int(element) else { return }
            let connect = connectBetweenTwoNodes(from: self.atoms[startPoint], to: self.atoms[endPoint])
            self.rootNode.addChildNode(connect)
        }
        
        
    }
    
    private func connectBetweenTwoNodes(from nodeA: SCNNode, to nodeB: SCNNode) -> SCNNode {
        
        var index: [Int32.Type] = [Int32.self, Int32.self]
        let position: [SCNVector3] = [nodeA.position, nodeB.position]
        let vertexSource: SCNGeometrySource = SCNGeometrySource(vertices: position)
        let indexData: Data = Data(bytes: &index, count:MemoryLayout<Int32>.size * index.count)
        
        let element: SCNGeometryElement = SCNGeometryElement(
            data: indexData,
            primitiveType: .line,
            primitiveCount: 1,
            bytesPerIndex: MemoryLayout<Int32>.size
        )
        
        let line: SCNGeometry = SCNGeometry(sources: [vertexSource], elements: [element])
        let lineNode: SCNNode = SCNNode(geometry: line)
        
        return lineNode
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
