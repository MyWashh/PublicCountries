import UIKit
import MapKit

struct MapCoordinator {
    private static func calculateRadius(area: Float) -> CLLocationDistance{
        let radius = CLLocationDistance(area.squareRoot()) * 1000
        return radius
    }

    private static func setupCoordinates(latitude: Double, longitude: Double) -> CLLocationCoordinate2D {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return location
    }

    static func setupMapRegion(country: Country) -> MKCoordinateRegion? {
        if country.latlng?.count == 2 {
            guard let area = country.area else { return nil }
            guard let latitude = country.latlng?[0] else { return nil }
            guard let longitude = country.latlng?[1] else { return nil }

            let radius = calculateRadius(area: area)
            let location = setupCoordinates(latitude: latitude, longitude: longitude)
            let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: radius, longitudinalMeters: radius)
            return coordinateRegion
        } else { return nil }

    }

}
