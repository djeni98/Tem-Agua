//
//  LocationCardView.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 10/10/21.
//

import UIKit
import SnapKit

class LocationCardView: CardView {
    private lazy var persistenceService = PersistenceService()
    private var locationPoint: LocationPoint?

    var editButtonAction: (() -> Void)?

    private lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = LayoutMetrics.stackViewSpacing

        return stackView
    }()

    private lazy var titleAndButton: TitleAndButtonView = {
        let view = TitleAndButtonView()
        view.title = "Localização"
        view.buttonText = "Definir"
        view.action = {
            self.editButtonAction?()
        }

        return view
    }()

    private lazy var latitudeView: CoordinateView = {
        let view = CoordinateView()
        view.title = "Latitude (y)"

        return view
    }()

    private lazy var longitudeView: CoordinateView = {
        let view = CoordinateView()
        view.title = "Longitude (x)"

        return view
    }()

    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.text = "Não definido"
        label.numberOfLines = 0

        return label
    }()

    private lazy var observationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.text = "Não definido"
        label.numberOfLines = 0

        return label
    }()

    private lazy var loadingView: UIView = {
        let label = UILabel()
        label.text = "Carregando..."
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        self.addSubview(container)
        let offset = LayoutMetrics.stackViewOffset
        container.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(offset)
            make.leading.equalToSuperview().offset(offset)
            make.trailing.equalToSuperview().offset(-offset)
        }

        self.snp.makeConstraints { make in
            make.bottom.equalTo(container).offset(offset)
        }

        configure(with: persistenceService.getLocationPoint())
    }

    func startEditing(withButtonText buttonText: String = "Trocar") {
        container.arrangedSubviews.forEach { view in
            container.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        container.addArrangedSubview(titleAndButton)
        titleAndButton.buttonText = buttonText
    }

    func finishEditing(with location: LocationPoint) {
        if let addressString = location.addressString {
            addressLabel.text = addressString
            container.addArrangedSubview(addressLabel)
        } else {
            latitudeView.value = "\(location.latitude)"
            longitudeView.value = "\(location.longitude)"
            container.addArrangedSubview(latitudeView)
            container.addArrangedSubview(longitudeView)
        }

        guard let observationText = location.getObservationText() else { return }
        observationLabel.text = observationText
        container.addArrangedSubview(observationLabel)
    }

    func configure(with location: LocationPoint?) {
        self.locationPoint = location

        startEditing(withButtonText: locationPoint == nil ? "Definir" : "Trocar")
        guard let locationPoint = locationPoint else { return }
        finishEditing(with: locationPoint)
    }

    func startLoadingAnimation() {
        print("Start loading")
        container.addArrangedSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
    }

    func finishLoadingAnimation() {
        print("End loading")
        container.removeArrangedSubview(loadingView)
        loadingView.removeFromSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private struct LayoutMetrics {
        static let stackViewSpacing: CGFloat = 12
        static let stackViewOffset: CGFloat = 16
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct LocationCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

    struct ContentView: UIViewRepresentable {

        func makeUIView(context: Context) -> UIView {
            return LocationCardView()
        }

        func updateUIView(_ uiView: UIView, context: Context) {}
    }
}
#endif
