import Alamofire

class NetworkService: NSObject {
    
    class func getProteinStructure(_ proteins: String, complition: @escaping([String]?)->()){
        
        let url: String = ModelsKeys.keyLinkFirstPart + proteins + ModelsKeys.keyLinkSecondPart
        Alamofire.download(url).responseData { (response) in
            if let data: Data = response.result.value{
                guard let result: String = String(data: data, encoding: String.Encoding.utf8) else {return}
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                complition(result.components(separatedBy: CharacterSet.newlines))
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                complition(nil)
            }
        }
    }
    
}
