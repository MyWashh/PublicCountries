import XCTest

@testable import Countries
class NetworkManagerTests: XCTestCase {

    func testNetworkRequest() {
        let networkManager = NetworkManager()
        let code = ["POL", "bolsdfla"]
        for i in 0...1 {
        let expectation = self.expectation(description: "wait for network task")
        networkManager.getCountryDetails(code: code[i]) { result in
            expectation.fulfill()
            DispatchQueue.main.async {
                switch result {
                case .success(let country):
                    XCTAssertEqual(country.name, "Poland")
                case .error:
                    XCTAssert(true)
                }
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    }
}
