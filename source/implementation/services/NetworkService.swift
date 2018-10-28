import Alamofire

class NetworkService: NSObject {
    
    class func getProteinStructure(_ proteins: String, complition: @escaping(ErrorHandle)->()){
        
        let url: String = ModelsKeys.keyLinkFirstPart + proteins + ModelsKeys.keyLinkSecondPart
        Alamofire.request(url).responseData { (response) in
            if let data: Data = response.result.value{
                guard let result: String = String(data: data, encoding: String.Encoding.utf8) else {return}
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                complition(ErrorHandle.success(Success(value: result.components(separatedBy: CharacterSet.newlines))))
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                complition(ErrorHandle.error(Error(value: response.error?.localizedDescription ?? "" )))
            }
        }
    }
    
}
