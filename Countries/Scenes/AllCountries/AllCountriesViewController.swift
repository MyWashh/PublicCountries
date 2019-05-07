import UIKit
import MBProgressHUD

class AllCountriesViewController: UIViewController {
    let tableView = UITableView()
    let countriesService: CountriesProtocol
    let tableViewDataSource: AllCountriesDataSource
    let searchController = UISearchController(searchResultsController: nil)
    let cellIdentifier = "CountryCell"

    init(countriesProtocol: CountriesProtocol) {
        countriesService = countriesProtocol
        tableViewDataSource = AllCountriesDataSource(countriesService: countriesService)
        super.init(nibName: nil, bundle: nil)
        setupSearchController()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Countries"
        setupTableView()
        bindTableView()
    }

    func setupTableView() {
        view.addSubview(tableView, constraints: [
            equal(\.leftAnchor),
            equal(\.rightAnchor),
            equal(\.topAnchor, view.safeAreaLayoutGuide.topAnchor),
            equal(\.bottomAnchor)
            ])
    }

    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search country"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: Table View Delegate
extension AllCountriesViewController: UITableViewDelegate {

    func bindTableView() {
        tableView.register(AllCountriesCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = tableViewDataSource
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let code = tableViewDataSource.countries?[indexPath.row].alpha3Code {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            countriesService.getCountryDetails(code: code) { country in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                self.present(CountryDetailViewController(name: country.name), animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension AllCountriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

    }
}
