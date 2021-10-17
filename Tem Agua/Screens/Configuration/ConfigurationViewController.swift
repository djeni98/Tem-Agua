//
//  ConfigurationViewController.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 10/10/21.
//

import UIKit
import SnapKit

class ConfigurationViewController: ScrollableViewController {
    private lazy var locationCard: LocationCardView = {
        let card = LocationCardView()
        card.editButtonAction = presentEditVC

        return card
    }()

    override func loadView() {
        super.loadView()

        navigationItem.title = "Configurações"
        view.backgroundColor = .appBackground
        setupContent()
    }

    private func setupContent() {
        contentStackView.alignment = .fill
        contentStackView.spacing = 16

        contentStackView.addArrangedSubview(locationCard)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    private func presentEditVC() {
        let editVC = EditLocationViewController()
        editVC.onStartEditing = {
            self.locationCard.startEditing()
            self.locationCard.startLoadingAnimation()
        }
        editVC.onFinishEditing = { location in
            self.locationCard.finishLoadingAnimation()
            self.locationCard.finishEditing(with: location)
        }

        let navController = UINavigationController(rootViewController: editVC)
        self.present(navController, animated: true, completion: nil)
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct ConfigurationViewController_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

    struct ContentView: UIViewControllerRepresentable {

        func makeUIViewController(context: Context) -> UIViewController {
            return ConfigurationViewController()
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }
}
#endif
