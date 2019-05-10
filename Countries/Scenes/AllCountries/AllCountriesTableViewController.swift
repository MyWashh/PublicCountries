import UIKit
import MBProgressHUD

class AllCountriesTableViewController: UITableViewController {
    let cellIdentifier = "CountryCell"
    var countries: [Country]?
    var countriesToDisplay: [Country]?
    let countriesService: CountriesProtocol

    init(countiresProtocol: CountriesProtocol) {
        self.countriesService = countiresProtocol
        super.init(nibName: nil, bundle: nil)
        getCountries()
        tableView.register(AllCountriesCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    func getCountries() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        countriesService.getCountries {result -> Void in
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    self.countries = countries
                    self.setCountriesToDisplay()
                    MBProgressHUD.hide(for: self.view, animated: true)
                case .error:
                    print("ooops something went wrong")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    AlertController.showAlert(on: self, message: "Couldn't download country list")
                }
            }
        }
    }

    func setCountriesToDisplay(name: String? = nil) {
        if let name = name {
            if name == "" {
                countriesToDisplay = countries
            } else {
                countriesToDisplay = filterCountries(name: name)
            }
            tableView.reloadData()
        } else {
            countriesToDisplay = countries
            tableView.reloadData()
        }
    }

    func filterCountries(name: String) -> [Country]? {
        let filtred = countries?.filter({(country: Country) -> Bool in
            return country.name.lowercased().contains(name.lowercased())
        })
        return filtred
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return countriesToDisplay?.count ?? 0
    }

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = AllCountriesCell(style: .default, reuseIdentifier: cellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AllCountriesCell ?? defaultCell
            cell.countryNameLabel.text = countriesToDisplay?[indexPath.row].name
        return cell
    }

   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let code = countriesToDisplay?[indexPath.row].alpha3Code else { return }
        presentCountryDetails(code: code)
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
