import Foundation
import UIKit

class ProteinService: ProteinDataModel{
    
    //MARK: - Public methods
    class func readFile() -> [String]?{
        
        guard let filePath = Bundle.main.url(forResource: ModelsKeys.keyFileName,
                                             withExtension: ModelsKeys.keyFileExtension) else { return nil }
        do {
            let data = try String(contentsOf: filePath, encoding: String.Encoding.utf8)
            return data.components(separatedBy: CharacterSet.newlines)
        } catch _ as NSError {
            return nil
        }
    }
    
    class func downloadLigandDataToItem(_ name: String, complition: @escaping(ErrorHandle)->()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkService.getProteinStructure(name) { (result) in complition(result) }
    }
}


