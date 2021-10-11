//
//  EditLocationViewController.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 10/10/21.
//

import UIKit

class EditLocationViewController: ScrollableViewController {

    private lazy var geolocationView: GeolocationCardView = {
        let view = GeolocationCardView()
        view.toggleAction = { geolocationSelected in
            self.pointFormView.selected = !geolocationSelected
        }

        return view
    }()

    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .secondaryLabel
        label.text = "OU"
        label.textAlignment = .center

        return label
    }()

    private lazy var pointFormView: PointFormCardView = .init()

    override func loadView() {
        super.loadView()

        view.backgroundColor = .appBackground
        setupContent()
        setupNavigationBar()
    }

    private func setupContent() {
        contentStackView.alignment = .fill
        contentStackView.spacing = 16

        contentStackView.addArrangedSubview(geolocationView)
        contentStackView.addArrangedSubview(orLabel)
        contentStackView.addArrangedSubview(pointFormView)
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.title = "Localização"
        let leftButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonPressed)
        )
        navigationItem.leftBarButtonItem = leftButton

        let rightButton = UIBarButtonItem(
            title: "Pronto",
            style: .done,
            target: self,
            action: #selector(doneButtonPressed)
        )
        navigationItem.rightBarButtonItem = rightButton
    }

    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }


    @objc private func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct EditLocationViewController_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

    struct ContentView: UIViewControllerRepresentable {

        func makeUIViewController(context: Context) -> UIViewController {
            let vc = EditLocationViewController()
            let navController = UINavigationController(rootViewController: vc)
            return navController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }
}
#endif
