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
        cellDetailsValues.append(handleOptionalStringDetails(detail: country.capital))
        cellDetailsValues.append(handleOptionalNumericDetails(detail: country.population))
        cellDetailsValues.append(handleOptionalNumericDetails(detail: country.area) + " km2")
        cellDetailsValues.append(handleOptionalStringDetails(detail: country.region))
    }

    func handleOptionalNumericDetails<T: LosslessStringConvertible>(detail: T?) -> String {
        if let detail = detail {
            return String(detail)
        } else {
            return "N/A"
        }
    }

    func handleOptionalStringDetails(detail: String?) -> String {
        guard let detail = detail else { return "N/A" }
        if detail == "" {
            return "N/A"
        } else { return detail }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = CountryDetailsCell(style: .default, reuseIdentifier: cellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CountryDetailsCell ?? defaultCell
        cell.detailLabel.text = cellDetails[indexPath.row]
        cell.detailValueLabel.text = cellDetailsValues[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDetails.count
    }
}
