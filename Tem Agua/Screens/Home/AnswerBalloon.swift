//
//  AnswerBalloon.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 07/10/21.
//

import UIKit
import SnapKit

class AnswerBalloon: RightBalloonView {
    private lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1).rounded().bold()
        label.adjustsFontForContentSizeCategory = true
        label.text = "...."
        label.textColor = .label

        return label
    }()

    private lazy var spinner: UIActivityIndicatorView = .init()

    private lazy var container: UIView = {
        let view = UIView()

        let vertical = LayoutMetrics.verticalOffset
        let horizontal = LayoutMetrics.horizontalOffset
        let inset = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
        view.addSubview(answerLabel)
        answerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(inset)
        }

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        self.rightBalloonCornerRadius()
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

    func setAnswer(_ answer: String) {
        answerLabel.text = answer
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private struct LayoutMetrics {
        static let horizontalOffset: CGFloat = 64 - 12
        static let verticalOffset: CGFloat = 8
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct AnswerBalloon_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

    struct ContentView: UIViewRepresentable {

        func makeUIView(context: Context) -> UIView {
            return AnswerBalloon()
        }

        func updateUIView(_ uiView: UIView, context: Context) {}
    }
}
#endif
