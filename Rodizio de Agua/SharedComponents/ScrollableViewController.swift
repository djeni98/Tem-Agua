//
//  ScrollableViewController.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 07/10/21.
//

import UIKit
import SnapKit

class ScrollableViewController: UIViewController {
    internal lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    internal lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical

        return stackView
    }()

    override func loadView() {
        super.loadView()

        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        setupScrollViewConstraints()
        setupContentStackViewConstraints()
    }

    internal func setupScrollViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    internal func setupContentStackViewConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }
}
