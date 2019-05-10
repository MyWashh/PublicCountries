import XCTest

@testable import Countries

class CountryDetailsTests: XCTestCase {
    let country = Country(name: "Poland", alpha3Code: "POL", population: 123, latlng: [15,15], area: 1200, region: "Europe", capital: "Warsaw")

    func testTableViewDatSourceIsCountryDetailsDataSource() {
        let detailsViewController = CountryDetailsViewController(country: country)
        XCTAssertTrue(detailsViewController.detailsTableView.dataSource is CountryDetailsDataSource)
    }

    func testDataSourceHasCountryDetails() {
        let country = Country(name: "Poland", alpha3Code: "POL", population: nil, latlng: [15,15], area: nil, region: "Europe", capital: "Warsaw")
        let dataSource = CountryDetailsDataSource(country: country)
        XCTAssertEqual(country.name, dataSource.cellDetailsValues[0])
        XCTAssertEqual(country.capital, dataSource.cellDetailsValues[1])
        XCTAssertNotEqual(String(country.population ?? 50), dataSource.cellDetailsValues[2])
        XCTAssertNotEqual(String(country.area ?? 60), dataSource.cellDetailsValues[3])
        XCTAssertEqual(country.region, dataSource.cellDetailsValues[4])
    }

    func testTableViewCellValue() {
        let dataSource = CountryDetailsDataSource(country: country)
        let tableView = UITableView()
        tableView.register(CountryDetailsCell.self, forCellReuseIdentifier: "DetailsCell")
        let cell = dataSource.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CountryDetailsCell
        XCTAssertEqual(cell?.detailValueLabel.text, country.name)
    }

    func testTableViewDetailsRowsNumber() {
        let dataSource = CountryDetailsDataSource(country: country)
        let tableView = UITableView()
        let numberOfRows = dataSource.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, dataSource.cellDetails.count)
    }
}
