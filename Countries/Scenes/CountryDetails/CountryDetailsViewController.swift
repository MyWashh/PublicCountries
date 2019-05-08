import UIKit
import MapKit

final class CountryDetailsViewController: UIViewController {
    let country: Country
    let map = MKMapView()
    let detailsTableView = UITableView()
    let cellIdentifier = "DetailsCell"
    let cellDetails: [String] = ["Name:", "Capital:", "Population:", "Area:", "Region:"]
    var cellDetailsValues: [String] = []

    func setupDetails() {
        cellDetailsValues.append(country.name)
        cellDetailsValues.append(country.capital ?? "N/A)")
        cellDetailsValues.append(String(country.population ?? 0))
        cellDetailsValues.append(String(country.area ?? 0) + " km2")
        cellDetailsValues.append(country.region ?? "N/A")
    }
    init(country: Country) {
        self.country = country
        super.init(nibName: nil, bundle: nil)
        bindTableView()
        setupDetails()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMap()
    }

    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissController))
        navigationItem.title = country.name
    }

    func setupLayout() {
        view.addSubview(map, constraints: [
            equal(\.topAnchor, view.safeAreaLayoutGuide.topAnchor, constant: 16),
            equal(\.leftAnchor, constant: 16),
            equal(\.rightAnchor, constant: -16),
            equal(\.heightAnchor, toConstant: 250)
        ])

        view.addSubview(detailsTableView, constraints: [
            equal(\.topAnchor, map.bottomAnchor, constant: 16),
            equal(\.leftAnchor),
            equal(\.rightAnchor),
            equal(\.heightAnchor, toConstant: 200)
        ])
    }

    func setupMap() {
        map.layer.cornerRadius = 15
        map.layer.masksToBounds = true
        if let region = MapCoordinator.setupMapRegion(country: country) {
            map.setRegion(region, animated: true)
            map.showsScale = true
            map.showsCompass = true
        } else {
            AlertController.showAlert(on: self, message: "Can't show correct map")
        }
    }

    @objc func dismissController() {
        dismiss(animated: true)
    }
}

// MARK: Table View
extension CountryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CountryDetailsCell ?? CountryDetailsCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.detailLabel.text = cellDetails[indexPath.row]
        cell.detailValueLabel.text = cellDetailsValues[indexPath.row]
        return cell
    }

    func bindTableView() {
        detailsTableView.register(CountryDetailsCell.self, forCellReuseIdentifier: cellIdentifier)
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
