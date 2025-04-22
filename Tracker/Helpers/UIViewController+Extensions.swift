//
//  UIViewController+Extensions.swift
//  Tracker
//
//  Created by Артем Солодовников on 21.04.2025.
//

import UIKit

extension UIViewController {
    func toRepresentAsSheet(_ viewController: UIViewController) {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.modalPresentationStyle = .pageSheet
        self.present(navigation, animated: true)
    }
    
    func dismissToRoot(animated: Bool = true) {
        var root = self
        while let presenter = root.presentingViewController {
            root = presenter
        }
        root.dismiss(animated: animated)
    }
    
    func enableHideKeyboardOnTap() {
        let tapToGest = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapToGest.cancelsTouchesInView = false
        view.addGestureRecognizer(tapToGest)
    }
    
    @objc private func hideKeyboardOnTap() {
        view.endEditing(true)
    }
}
