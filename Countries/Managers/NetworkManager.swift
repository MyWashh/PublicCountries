import UIKit

class NetworkManager: CountriesProtocol {
    func requestData<T: Decodable>(withURL url: String, onCompleted: @escaping ([T]) -> Void) {
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url) {(data, _, _) in
            guard let data = data else {return}
            do {
                let countries = try JSONDecoder().decode([T].self, from: data)
                onCompleted(countries)
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }

    func requestData<T: Decodable>(withURL url: String, onCompleted: @escaping (T) -> Void) {
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url) {(data, _, _) in
            guard let data = data else {return}
            do {
                let country = try JSONDecoder().decode(T.self, from: data)
                onCompleted(country)
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }

    func getAllCountries(onCompleted: @escaping ([Country]) -> Void) {
        let url = "https://restcountries.eu/rest/v2/all?fields=name;alpha3Code"
        requestData(withURL: url) { (country: [Country]) in
            onCompleted(country)
        }
    }

    func getCountryDetails(code: String, onCompleted: @escaping (Country) -> Void) {
        let fields = "?fields=name;capital;population;latlng;alpha3Code"
        let url = "https://restcountries.eu/rest/v2/alpha/" + code + fields
        requestData(withURL: url) { (country: Country) in
            onCompleted(country)
        }
    }

}
