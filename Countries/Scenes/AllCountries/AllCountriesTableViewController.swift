import UIKit

class AllCountriesTableViewController: UITableViewController {
    let cellIdentifier = "CountryCell"
    var countries: [Country]?
    var filteredCountries: [Country]?
    let searchController: UISearchController

    init(searchController: UISearchController) {
        self.searchController = searchController
        super.init(nibName: nil, bundle: nil)
        tableView.register(AllCountriesCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCountries?.count ?? 0
        }
        return countries?.count ?? 0
    }

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = AllCountriesCell(style: .default, reuseIdentifier: cellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AllCountriesCell ?? defaultCell
        if isFiltering() {
            cell.countryNameLabel.text = filteredCountries?[indexPath.row].name
        } else {
            cell.countryNameLabel.text = countries?[indexPath.row].name
        }
        return cell
    }

   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}
