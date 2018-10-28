import UIKit

class ProteinListViewController: UIViewController {
    
    //MARK: - Private properies
    fileprivate let proteins: ProteinDataModel = ProteinDataModel.getProteins()
    fileprivate var index: Int?
    fileprivate var isSearch: Bool = false
    fileprivate var searchProteins: [Protein] = []
    
    //MARK: - IBOutlet
    @IBOutlet weak var proteinsTableView: UITableView!
    @IBOutlet weak var proteinSearchBar: UISearchBar!
    
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTableView()
        
        CurrentViewContoller.shared.currentViewController = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ProteinViewController.className() {
            let controller = segue.destination as? ProteinViewController
            
            if let index = self.index{
                guard let list: Protein = self.proteins.list?[index] else { return }
                controller?.protein = Protein(
                    name: list.name,
                    ligand: list.ligand
                )
            }
        }
    }
    
    //MARK: - Private methods
    private func setTableView(){
        self.proteinsTableView.delegate = self as UITableViewDelegate
        self.proteinSearchBar.delegate = self as UISearchBarDelegate
        self.proteinsTableView.dataSource = self as UITableViewDataSource
        self.proteinsTableView.register(ProteinTableViewCell.nib(),
                                        forCellReuseIdentifier: ProteinTableViewCell.className())
        self.proteinsTableView.backgroundColor = UIColor.gray
        self.proteinsTableView.separatorColor = UIColor.clear
    }
    
    
}

//MARK: - Extension Table View Data Source

extension ProteinListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearch{
            return searchProteins.count == 0 ? 1 : searchProteins.count
        }
        guard let rowsCount = proteins.list?.count else {return 1}
        
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.proteinsTableView.dequeueReusableCell(
            withIdentifier: ProteinTableViewCell.className()) as! ProteinTableViewCell
        if isSearch {
            cell.proteinNameLabel.text = searchProteins.count == 0 ? "Nothing find!" : self.searchProteins[indexPath.row].name
        } else {
            guard let protein: Protein = proteins.list?[indexPath.row] else { return UITableViewCell() }
            cell.proteinNameLabel.text = protein.name
        }
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.gray : UIColor.darkGray
        return cell
    }
    
    
}

//MARK: - Extension Table View Delegate

extension ProteinListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: ProteinTableViewCell = tableView.cellForRow(at: indexPath) as! ProteinTableViewCell
        
        guard let proteinName: String = cell.proteinNameLabel.text else { return }
        guard let list: [Protein] = self.proteins.list else { return }
        var count = 0
        list.forEach { (item) in
            if item.name == proteinName{
                self.index = count
            }
            count = count + 1
        }
        
        if list.contains(where: { (item) -> Bool in
            return item.name == proteinName  && item.ligand == nil ? true : false
        }){
            self.proteins.addLigandToItem(proteinName) { (response) in
                switch response {
                case .success(_):
                    self.performSegue(withIdentifier: ProteinViewController.className(), sender: nil)
                case .error(let result):
                    self.showErrorAlertWith(message: result.value)
                }
            }
        } else if list.contains(where: { (item) -> Bool in
            return item.name == proteinName  && item.ligand != nil ? true : false
        }){
            self.performSegue(withIdentifier: ProteinViewController.className(), sender: nil)
        }
        else {
            self.showErrorAlertWith(message: "Have some problem with item \(proteinName)!")
        }
    }
}


//MARK: - Extension Search Bar s Delegate

extension ProteinListViewController: UISearchBarDelegate{
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isSearch = true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearch = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearch = false;
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.isSearch = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let data: [Protein] = self.proteins.list else { return }
        searchProteins = data.filter({ (item) -> Bool in
            let temp: NSString = item.name as NSString
            let range = temp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if searchText.isEmpty{
            self.isSearch = false
        }else {
            self.isSearch = true
        }
        
        self.proteinsTableView.reloadData()
    }
}
