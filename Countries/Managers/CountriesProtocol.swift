import UIKit

protocol CountriesProtocol {
    func getCountries(onCompleted: @escaping ((Result<[Country]>)) -> Void)
    func getCountryDetails(code: String, onCompleted: @escaping (Result<Country>) -> Void)
}
