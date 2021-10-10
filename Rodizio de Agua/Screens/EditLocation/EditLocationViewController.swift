//
//  EditLocationViewController.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 10/10/21.
//

import UIKit

class EditLocationViewController: ScrollableViewController {

    override func loadView() {
        super.loadView()

        view.backgroundColor = .appBackground
        setupContent()
        setupNavigationBar()
    }

    private func setupContent() {
        contentStackView.alignment = .fill
        contentStackView.spacing = 16
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
        rightButton.isEnabled = false
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
