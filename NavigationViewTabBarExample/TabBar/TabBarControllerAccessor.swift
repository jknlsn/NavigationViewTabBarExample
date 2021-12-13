//
//  TabBarControllerAccessor.swift
//  Mixtapes
//
//  Created by Jake Nelson on 10/11/21.
//

import Foundation
import SwiftUI

// Helper bridge to UIViewController to access enclosing UITabBarController
// and thus its UITabBarController, same as UITabBar

struct TabBarControllerAccessor: UIViewControllerRepresentable {
    var callback: (UITabBarController) -> Void
    private let proxyController = ViewController()

    func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarControllerAccessor>) ->
                              UIViewController {
        proxyController.callback = callback
        return proxyController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TabBarControllerAccessor>) {
    }

    typealias UIViewControllerType = UIViewController

    private class ViewController: UIViewController {
        var callback: (UITabBarController) -> Void = { _ in }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let tabBar = self.tabBarController {
                self.callback(tabBar)
            }
        }
    }
}
