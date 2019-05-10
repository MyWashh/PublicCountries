import UIKit

enum Result<T> {
    case success(T)
    case error
}

class NetworkManager: CountriesProtocol {
    private func requestData<T: Decodable>(withURL url: String, onCompleted: @escaping (Result<T>) -> Void) {
        guard let url = URL(string: url) else { return }
        let session = setupSession()
        session.dataTask(with: url) {(data, _, error) in
            if error != nil {
                onCompleted(Result.error)
            }
            guard let data = data else {return}
            do {
                let country = try JSONDecoder().decode(T.self, from: data)
                onCompleted(Result.success(country))
            } catch {
                onCompleted(Result.error)
            }
            }.resume()
    }

    private func setupSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = false
        let session = URLSession(configuration: configuration)
        return session
    }

    func getCountries(onCompleted: @escaping (Result<[Country]>) -> Void) {
        let url = "https://restcountries.eu/rest/v2/all?fields=name;alpha3Code"
        requestData(withURL: url) { result in
            onCompleted(result)
        }
    }

    func getCountryDetails(code: String, onCompleted: @escaping (Result<Country>) -> Void) {
        let fields = "?fields=name;capital;population;latlng;alpha3Code;area;region;flag"
        let url = "https://restcountries.eu/rest/v2/alpha/" + code + fields
        requestData(withURL: url) { result in
            onCompleted(result)
        }
    }
}
