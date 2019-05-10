import UIKit

final class CountryDetailsCell: UITableViewCell {
    let detailLabel = UILabel()
    let detailValueLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addSubview(detailLabel, constraints: [
            equal(\.leftAnchor, constant: 16),
            equal(\.centerYAnchor)
        ])

        addSubview(detailValueLabel, constraints: [
            equal(\.rightAnchor, rightAnchor, constant: -16),
            equal(\.centerYAnchor)
        ])
    }
}
