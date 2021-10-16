//
//  TitleAndButtonView.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 10/10/21.
//

import UIKit
import SnapKit

class TitleAndButtonView: UIView {
    var title: String? {
        didSet { titleLabel.text = title }
    }

    var buttonText: String? {
        didSet { button.setTitle(buttonText, for: .normal) }
    }

    var action: (() -> Void)?
    private lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(button)
        stackView.alignment = .firstBaseline

        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = .preferredFont(forTextStyle: .title1).bold()
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0

        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Button", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)

        button.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
        }

        return button
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

    @objc private func buttonAction() {
        guard let action = action else {
            print("\(#file): Action not defined")
            return
        }

        action()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct TitleAndButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

    struct ContentView: UIViewRepresentable {

        func makeUIView(context: Context) -> UIView {
            return TitleAndButtonView()
        }

        func updateUIView(_ uiView: UIView, context: Context) {}
    }
}
#endif
