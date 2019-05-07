import UIKit
import MBProgressHUD

class AllCountriesViewController: UIViewController {
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

// MARK: Table View
extension AllCountriesViewController: UITableViewDelegate, UITableViewDataSource {
    func bindTableView() {
        tableView.register(AllCountriesCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countriesService.getAllCountries {country -> Void in
            self.countries = country
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        if isFiltering() {
            return filteredCountries?.count ?? 0
        }
        return countries?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AllCountriesCell ?? AllCountriesCell(style: .default, reuseIdentifier: cellIdentifier)
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
        countriesService.getCountryDetails(code: code) { country in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.present(CountryDetailViewController(name: country.name), animated: true, completion: nil)
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
