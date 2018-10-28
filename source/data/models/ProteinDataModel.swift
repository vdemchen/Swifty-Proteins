import Foundation


struct Protein {
    let name: String
    var ligand: [String]?
    
    init(name: String, ligand: [String]? = nil) {
        self.name = name
        self.ligand = ligand
    }
    init() {
        self.name = ""
        self.ligand = nil
    }
}

class ProteinDataModel: NSObject{
    
    //MARK: - Public properties
    var list: [Protein]?
    
    //MARK: - Private properties
    private static var shareFile: ProteinDataModel?
    
    //MARK: - Override
    override private init() {
        super.init()
        
        guard let list: [String] = ProteinService.readFile() else { return }
        self.list = self.createProteinsDictionary(list)
    }
    
    //MARK: - Public methods
    static func getProteins() -> ProteinDataModel{
        
        if let file: ProteinDataModel = self.shareFile{
            return file
        } else {
            let file: ProteinDataModel = ProteinDataModel()
            self.shareFile = file
            return file
        }
        
    }
    
    //MARK: - Public methods
    func addLigandToItem(_ name: String, complition: @escaping(ErrorHandle)->()){
        guard let list: [Protein] = self.list else { return }
        var count: Int =  0
        var editItemIndex: Int? = nil
        
        list.forEach({ (item) in
            if item.name == name {
                editItemIndex = count
            }
            count = count + 1
        })
        guard editItemIndex != nil else { return }
        self.list?.remove(at: editItemIndex!)
        
        ProteinService.downloadLigandDataToItem(name) { (response) in
            
            switch response{
            case .success(let result):
                let newItem: Protein = Protein(name: name, ligand: result.value)
                self.list?.insert(newItem, at: editItemIndex!)
                complition(ErrorHandle.success(Success(value: [String]())))
            case .error(let result):
                print(result.value)
                complition(ErrorHandle.error(Error(value: "Can`t download Ligard from web page")))
            }
        }
    }
    
    //MARK: - Private methods
    private func createProteinsDictionary(_ proteinsList: [String]) -> [Protein]{
        var result: [Protein] = [Protein]()
        
        for item in proteinsList{
            let newProtein = Protein(name: item)
            result.append(newProtein)
        }
        
        return result
    }
}
