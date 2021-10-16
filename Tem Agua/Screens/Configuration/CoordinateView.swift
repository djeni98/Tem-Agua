//
//  CoordinateView.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 10/10/21.
//

import UIKit
import SnapKit

class CoordinateView: UIView {
    var title: String? {
        didSet { titleLabel.text = title }
    }

    var value: String? {
        didSet { valueLabel.text = value }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.text = "Title"
        label.numberOfLines = 0

        return label
    }()

    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.text = "Value"
        label.numberOfLines = 0

        return label
    }()

    private lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = LayoutMetrics.stackViewSpacing

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        self.addSubview(container)
        container.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        self.snp.makeConstraints { make in
            make.bottom.equalTo(container)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private struct LayoutMetrics {
        static let stackViewSpacing: CGFloat = 4
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct CoordinateView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

    struct ContentView: UIViewRepresentable {

        func makeUIView(context: Context) -> UIView {
            return CoordinateView()
        }

        func updateUIView(_ uiView: UIView, context: Context) {}
    }
}
#endif
