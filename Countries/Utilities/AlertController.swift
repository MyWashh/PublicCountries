import UIKit

final class AlertController {
    static func showAlert(on controller: UIViewController, title: String? = nil, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title ?? "Error", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Ok", style: .default, handler: completion)
        alert.addAction(confirm)
        controller.present(alert, animated: true)
    }
}
