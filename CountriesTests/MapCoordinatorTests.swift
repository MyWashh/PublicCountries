import XCTest

@testable import Countries
class MapCoordinatorTests: XCTestCase {
   let country = Country(name: "Poland", alpha3Code: "POL", population: 123, latlng: [15.25, 15.83], area: 1200, region: "Europe", capital: "Warsaw")

    func testMapCoordinator() {
        let region = MapCoordinator.setupMapRegion(country: country)
        XCTAssertEqual(region?.center.latitude, country.latlng?[0])
        XCTAssertEqual(region?.center.longitude, country.latlng?[1])
    }
}
