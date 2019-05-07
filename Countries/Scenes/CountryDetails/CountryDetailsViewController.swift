import UIKit

class CountryDetailViewController: UIViewController {
    let countryName: String

    init(name: String) {
        countryName = name
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        createLabel()
    }

    func createLabel() {
        let label = UILabel()
        label.text = countryName
        view.addSubview(label, constraints: [
            equal(\.centerXAnchor),
            equal(\.centerYAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
