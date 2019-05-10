import XCTest

@testable import Countries

class AllCountriesTests: XCTestCase {
    let country = Country(name: "Poland", alpha3Code: "POL", population: 123, latlng: [15,15], area: 1200, region: "Europe", capital: "Warsaw")

    func testCountriesToDisplay() {
        let controller = AllCountriesTableViewController(countiresProtocol: NetworkManager())
        controller.countries = [country]
        controller.setCountriesToDisplay(name: "Germany")
        XCTAssertNotEqual(controller.countriesToDisplay?.count, controller.countries?.count)
        controller.setCountriesToDisplay(name: "")
        XCTAssertEqual(controller.countriesToDisplay?.count, controller.countries?.count)
    }
}
