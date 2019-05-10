import UIKit

protocol CountriesProtocol {
    func getCountries(onCompleted: @escaping ((Result<[Country], Bool>)) -> Void)
    func getCountryDetails(code: String, onCompleted: @escaping (Result<Country, Bool>) -> Void)
}
