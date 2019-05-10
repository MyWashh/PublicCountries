import UIKit
import MBProgressHUD

final class AllCountriesViewController: UIViewController {
    let tableViewController: AllCountriesTableViewController
    let countriesService: CountriesProtocol
    let searchController = UISearchController(searchResultsController: nil)
    let cellIdentifier = "CountryCell"

    init(countriesProtocol: CountriesProtocol) {
        countriesService = countriesProtocol
        self.tableViewController = AllCountriesTableViewController(countiresProtocol: countriesProtocol)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
    }

    func setupNavigationBar() {
        navigationItem.title = "Countries"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTableView))
        setupSearchController()

    }

    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search country"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func setupTableView() {
        addChild(tableViewController)
        view.addSubview(tableViewController.tableView, constraints: [
            equal(\.leftAnchor),
            equal(\.rightAnchor),
            equal(\.topAnchor, view.safeAreaLayoutGuide.topAnchor),
            equal(\.bottomAnchor)
        ])
    }

    @objc func refreshTableView() {
        tableViewController.getCountries()
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension AllCountriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    func filterContentForSearchText(_ searchText: String) {
        tableViewController.setCountriesToDisplay(name: searchText)
    }
}
