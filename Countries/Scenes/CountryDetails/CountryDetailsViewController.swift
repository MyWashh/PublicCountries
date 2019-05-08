import UIKit
import MapKit

final class CountryDetailsViewController: UIViewController {
    let country: Country
    let map = MKMapView()
    let detailsTableView = UITableView()
    let cellIdentifier = "DetailsCell"
    let tableViewDataSource: CountryDetailsDataSource

    init(country: Country) {
        self.country = country
        tableViewDataSource = CountryDetailsDataSource(country: country)
        super.init(nibName: nil, bundle: nil)
        bindTableView()
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
            AlertController.showAlert(on: self, title: "Region error", message: "Couldn't show correct area", completion: nil)
        }
    }

    @objc func dismissController() {
        dismiss(animated: true)
    }
}

// MARK: Table View
extension CountryDetailsViewController: UITableViewDelegate {
    func bindTableView() {
        detailsTableView.register(CountryDetailsCell.self, forCellReuseIdentifier: cellIdentifier)
        detailsTableView.delegate = self
        detailsTableView.dataSource = tableViewDataSource
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
