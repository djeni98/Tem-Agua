//
//  EditLocationViewController.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 10/10/21.
//

import UIKit
import SnapKit
import CoreLocation

class EditLocationViewController: ScrollableViewController {
    private lazy var persistence: PersistenceService = .init()

    private lazy var geolocationView: GeolocationCardView = {
        let view = GeolocationCardView()
        view.toggleAction = { geolocationSelected in
            self.pointFormView.selected = !geolocationSelected
            if self.pointFormView.selected {
                self.contentStackView.addArrangedSubview(self.buttonsContainer)
            } else {
                self.contentStackView.removeArrangedSubview(self.buttonsContainer)
                self.buttonsContainer.removeFromSuperview()
            }
        }

        return view
    }()

    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.text = "OU"
        label.textAlignment = .center

        return label
    }()

    private lazy var pointFormView: PointFormCardView = .init()

    private lazy var buttonsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillProportionally

        for (index, location) in LocationPoint.examplePoints().enumerated() {
            let uiAction = UIAction() { _ in
                self.pointFormView.latitude = location.latitude
                self.pointFormView.longitude = location.longitude
            }

            let button = UIButton(primaryAction: uiAction)
            let relatedName = location.relatedName!

            let title = "\(relatedName)\n(Grupo \(index + 1))"
            button.setTitle(title, for: .normal)
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.titleLabel?.textAlignment = .center

            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 10
            button.snp.makeConstraints { make in
                make.height.equalTo(60)
            }

            stackView.addArrangedSubview(button)
        }

        return stackView
    }()


    var onStartEditing: (() -> Void)?
    var onFinishEditing: ((LocationPoint) -> Void)?

    private var locationManager: CLLocationManager!

    override func loadView() {
        super.loadView()

        view.backgroundColor = .appBackground
        setupContent()
        setupNavigationBar()

        setupLocationPoint()
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
            title: "Cancelar",
            style: .plain,
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

    private func setupLocationPoint() {
        guard let locationPoint = persistence.getLocationPoint() else { return }
        if let source = locationPoint.source, source == .manually {
            geolocationView.selected = false

            pointFormView.selected = true
            pointFormView.latitude = locationPoint.latitude
            pointFormView.longitude = locationPoint.longitude

            contentStackView.addArrangedSubview(buttonsContainer)
        }
    }

    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    private func notImplementedAlert() {
        let alert = UIAlertController(
            title: "Não implementado",
            message: nil,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    private func invalidFormAlert() {
        let alert = UIAlertController(
            title: "Latitude e longitude inválidos",
            message: nil,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    private func locationServiceDeniedAlert() {
        let alert = UIAlertController(
            title: "Sem permissão",
            message: "Altere as permissões de localização do app.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)

    }

    @objc private func doneButtonPressed() {
        if geolocationView.selected {
            let status = locationManager.authorizationStatus

            if status == .restricted || status == .denied {
                locationServiceDeniedAlert()
            } else {
                onStartEditing?()
                locationManager.requestLocation()
                self.dismiss(animated: true, completion: nil)
            }

            return
        } else {
            guard let latitude = pointFormView.latitude,
                  let longitude = pointFormView.longitude
            else {
                invalidFormAlert()
                return
            }

            let location = LocationPoint(latitude: latitude, longitude: longitude, relatedName: nil, source: .manually, obtainedAt: Date())

            onStartEditing?()
            persistence.saveLocationPoint(location)
            onFinishEditing?(location)
        }

        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self

        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension EditLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation] ) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            let location = LocationPoint(latitude: latitude, longitude: longitude, relatedName: nil, source: .geolocalization, obtainedAt: Date())

            persistence.saveLocationPoint(location)
            onFinishEditing?(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(
            title: "Não foi possível obter sua localização",
            message: "Tente novamente mais tarde.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            self.geolocationView.selected = false
            if !self.pointFormView.selected {
                self.pointFormView.selected = true
                self.contentStackView.addArrangedSubview(self.buttonsContainer)
            }
        }
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
