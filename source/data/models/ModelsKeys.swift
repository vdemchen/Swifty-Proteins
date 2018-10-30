import UIKit

class ModelsKeys: NSObject{
    
     static let keyBackGroud = "background.png"
    
    //MARK: - File keys
    static let keyFileName = "ligands"
    static let keyFileExtension = "txt"
    
    //MARK: - Request keys
    static let keyLinkFirstPart = "https://files.rcsb.org/ligands/view/"
    static let keyLinkSecondPart = "_ideal.pdb"

    //MARK: - Keys to atom file array
    static let keyType = 0
    static let keyAtomNumber = 1
    static let keyAtomName = 2
    static let keyPointX = 6
    static let keyPointY = 7
    static let keyPointZ = 8
    static let keyElementSymbol = 11
    
    //MARK: - Key of value types
    static let keyAtom = "ATOM"
    static let keyConect = "CONECT"
}
