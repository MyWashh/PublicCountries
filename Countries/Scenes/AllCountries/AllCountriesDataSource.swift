import UIKit

class AllCountriesDataSource: NSObject, UITableViewDataSource {
    var countries: [Country]?
    let countriesService: CountriesProtocol
    let cellIdentifier = "CountryCell"

    init(countriesService: CountriesProtocol) {
        self.countriesService = countriesService
        super.init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countriesService.getAllCountries {country -> Void in
            self.countries = country
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        return countries?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AllCountriesCell ?? AllCountriesCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.countryNameLabel.text = countries?[indexPath.row].name
        return cell
    }
}
