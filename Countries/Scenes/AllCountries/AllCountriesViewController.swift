import UIKit
import MBProgressHUD

final class AllCountriesViewController: UIViewController {
    let tableViewController: AllCountriesTableViewController
    let countriesService: CountriesProtocol
    let searchController = UISearchController(searchResultsController: nil)
    let cellIdentifier = "CountryCell"

    init(countriesProtocol: CountriesProtocol) {
        countriesService = countriesProtocol
        self.tableViewController = AllCountriesTableViewController()
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
        getCountries()
    }

    func getCountries() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        countriesService.getCountries {result -> Void in
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    self.tableViewController.countries = countries
                    self.tableViewController.tableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                case .error:
                    print("ooops something went wrong")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    AlertController.showAlert(on: self, message: "Couldn't download country list")
                }
            }
        }
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
        getCountries()
        tableViewController.tableView.delegate = self
        view.addSubview(tableViewController.tableView, constraints: [
            equal(\.leftAnchor),
            equal(\.rightAnchor),
            equal(\.topAnchor, view.safeAreaLayoutGuide.topAnchor),
            equal(\.bottomAnchor)
        ])
    }

    @objc func refreshTableView() {
        getCountries()
    }
}

// MARK: Table View
extension AllCountriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.isActive = true
    //
//        if isFiltering() {
//            guard let code = tableViewController.filteredCountries?[indexPath.row].alpha3Code else { return }
//            presentCountryDetails(code: code)
//        } else {
//            guard let code = tableViewController.countries?[indexPath.row].alpha3Code else { return }
//            presentCountryDetails(code: code)
//        }
    }

    func presentCountryDetails(code: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        countriesService.getCountryDetails(code: code) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let country):
                    let countryDetailsController = CountryDetailsViewController(country: country)
                    let navigationController = UINavigationController(rootViewController: countryDetailsController)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.present(navigationController, animated: true, completion: nil)
                case .error:
                    MBProgressHUD.hide(for: self.view, animated: true)
                    AlertController.showAlert(on: self, message: "Couldn't load details")
                }
            }
        }
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension AllCountriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String) {
        tableViewController.filteredCountries = tableViewController.countries?.filter({(country: Country) -> Bool in
            return country.name.lowercased().contains(searchText.lowercased())
        })
        tableViewController.tableView.reloadData()
    }

    func isFiltering() -> Bool {
        let isFiltering = searchController.isActive && !searchBarIsEmpty()
        tableViewController.isFiltering = isFiltering
        return isFiltering
    }
}
