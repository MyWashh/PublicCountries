import UIKit

final class AllCountriesCell: UITableViewCell {

    let countryNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addSubview(countryNameLabel, constraints: [
            equal(\.leftAnchor, constant: 16),
            equal(\.centerYAnchor)
        ])
    }
}
