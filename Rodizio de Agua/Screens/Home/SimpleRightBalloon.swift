//
//  SimpleRightBalloon.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 12/10/21.
//

import UIKit
import SnapKit

class SimpleRightBalloon: RightBalloonView {
    var text: String? {
        didSet { label.text = text }
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "Some label"
        label.textColor = .label
        label.numberOfLines = 0

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.rightBalloonCornerRadius()
        setup()
    }

    private func setup() {
        self.addSubview(label)
        let offset = CGFloat(8)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(offset)
            make.leading.equalToSuperview().offset(offset)
            make.trailing.equalToSuperview().offset(-offset)
        }

        self.snp.makeConstraints { make in
            make.bottom.equalTo(label).offset(offset)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct SimpleRightBalloon_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

    struct ContentView: UIViewRepresentable {

        func makeUIView(context: Context) -> UIView {
            return SimpleRightBalloon()
        }

        func updateUIView(_ uiView: UIView, context: Context) {}
    }
}
#endif
