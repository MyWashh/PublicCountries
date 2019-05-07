import UIKit

protocol CountriesProtocol {
    func getAllCountries(onCompleted: @escaping ([Country]) -> Void)
    func getCountryDetails(code: String, onCompleted: @escaping (Country) -> Void)
}
