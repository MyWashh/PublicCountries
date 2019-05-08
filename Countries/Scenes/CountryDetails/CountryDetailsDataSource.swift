import UIKit

class CountryDetailsDataSource: NSObject, UITableViewDataSource {
    let cellIdentifier = "DetailsCell"
    let cellDetails: [String] = ["Name:", "Capital:", "Population:", "Area:", "Region:"]
    var cellDetailsValues: [String] = []
    let country: Country

    init(country: Country) {
        self.country = country
        super.init()
        setupDetailsValues()
    }

    func setupDetailsValues() {
        cellDetailsValues.append(country.name)
        cellDetailsValues.append(country.capital ?? "N/A")
        cellDetailsValues.append(String(country.population ?? 0))
        cellDetailsValues.append(String(country.area ?? 0) + " km2")
        cellDetailsValues.append(country.region ?? "N/A")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = CountryDetailsCell(style: .default, reuseIdentifier: cellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CountryDetailsCell ?? defaultCell
        cell.detailLabel.text = cellDetails[indexPath.row]
        cell.detailValueLabel.text = cellDetailsValues[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
