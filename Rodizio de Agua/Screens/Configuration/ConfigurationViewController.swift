//
//  ConfigurationViewController.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 10/10/21.
//

import UIKit
import SnapKit

class ConfigurationViewController: ScrollableViewController {

    private lazy var locationCard: LocationCardView = .init()

    override func loadView() {
        super.loadView()

        view.backgroundColor = .appBackground
        setupContent()
    }

    override func setupContentStackViewConstraints() {
        let vertical = ScreensLayoutMetrics.contentStackViewVerticalOffset
        let horizontal = ScreensLayoutMetrics.contentStackViewHorizontalOffset

        let inset = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView).inset(inset)
            make.width.equalTo(scrollView).offset(-horizontal*2)
        }
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
