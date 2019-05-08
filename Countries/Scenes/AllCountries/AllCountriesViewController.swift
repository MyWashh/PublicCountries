import UIKit
import MBProgressHUD

final class AllCountriesViewController: UIViewController {
    let tableView = UITableView()
    let countriesService: CountriesProtocol
    let searchController = UISearchController(searchResultsController: nil)
    let cellIdentifier = "CountryCell"
    var countries: [Country]?
    var filteredCountries: [Country]?

    init(countriesProtocol: CountriesProtocol) {
        countriesService = countriesProtocol
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTableView))
        setupTableView()
        bindTableView()
        getCountries()
    }

    @objc func refreshTableView() {
        getCountries()
    }

    func getCountries() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        countriesService.getCountries {result -> Void in
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    self.countries = countries
                    self.tableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                case .error:
                    print("ooops something went wrong")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    AlertController.showAlert(on: self, message: "Couldn't download country list")
                }
            }
        }
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

// MARK: Table View
extension AllCountriesViewController: UITableViewDelegate, UITableViewDataSource {
    func bindTableView() {
        tableView.register(AllCountriesCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCountries?.count ?? 0
        }
        return countries?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = AllCountriesCell(style: .default, reuseIdentifier: cellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AllCountriesCell ?? defaultCell
        if isFiltering() {
            cell.countryNameLabel.text = filteredCountries?[indexPath.row].name
        } else {
            cell.countryNameLabel.text = countries?[indexPath.row].name
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering() {
            guard let code = filteredCountries?[indexPath.row].alpha3Code else { return }
            presentCountryDetails(code: code)
        } else {
            guard let code = countries?[indexPath.row].alpha3Code else { return }
            presentCountryDetails(code: code)
        }
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
        filteredCountries = countries?.filter({(country: Country) -> Bool in
            return country.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}
