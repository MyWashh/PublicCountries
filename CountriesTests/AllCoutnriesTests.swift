import XCTest

@testable import Countries

class AllCountriesTests: XCTestCase {
    func testTableView() {
        let vc = AllCountriesViewController(countriesProtocol: NetworkManager())
        vc.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        vc.tableViewController.tableView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        vc.loadViewIfNeeded()
        vc.viewDidLoad()

        let controller = vc.tableViewController
        controller.searchController.searchBar.becomeFirstResponder()
        controller.searchController.isActive = true
        controller.searchController.searchBar.text = "poland"
        XCTAssertTrue(controller.searchController.isActive)


        let country = Country(name: "Poland", alpha3Code: "POL", population: 123, latlng: [15,15], area: 1200, region: "Europe", capital: "Warsaw")
        controller.countries = [country]
        controller.filteredCountries = [country]
        controller.tableView.register(AllCountriesCell.self, forCellReuseIdentifier: "CountryCell")
        let cell = controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? AllCountriesCell
        let numberOfRows = controller.tableView(controller.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, 1)
        XCTAssertEqual(cell?.countryNameLabel.text, controller.filteredCountries?[0].name)
        
    }
}
