import Foundation

struct Country: Decodable {
    let name: String
    let alpha3Code: String
    let population: Int?
    let latlng: [Double]?
    let area: Float?
    let region: String?
    let capital: String?
}
