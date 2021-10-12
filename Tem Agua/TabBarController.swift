//
//  TabBarController.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 12/10/21.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 0

        // Do any additional setup after loading the view.
        let viewControllers = [getHomeVC(), getConfigurationVC()]
        setViewControllers(viewControllers, animated: false)
    }

    private func getHomeVC() -> UIViewController {
        let viewController = UINavigationController(rootViewController: HomeViewController())
        let tabBarItem = UITabBarItem(title: "Início", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        tabBarItem.tag = 0

        viewController.tabBarItem = tabBarItem
        viewController.navigationBar.setBackgroundHidden()

        return viewController
    }

    private func getConfigurationVC() -> UIViewController {
        let viewController = UINavigationController(rootViewController: ConfigurationViewController())
        let tabBarItem = UITabBarItem(title: "Configurações", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        tabBarItem.tag = 1

        viewController.tabBarItem = tabBarItem
        viewController.navigationBar.setBackgroundHidden()

        return viewController
    }

}
