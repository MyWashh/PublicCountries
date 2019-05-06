import UIKit

class AllCountriesViewController: UIViewController {
    let tableView = UITableView()
    let tableViewDataSource = AllCountriesDataSource()
    let searchController = UISearchController(searchResultsController: nil)

    init() {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        tableView.register(AllCountriesCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.delegate = self
        tableView.dataSource = tableViewDataSource
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

}

// MARK: - UISearchResultsUpdating Delegate
extension AllCountriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

    }
}
