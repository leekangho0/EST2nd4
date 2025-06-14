//
//  LocationStepView.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/12/25.
//

import UIKit

class LocationStepView: UIView {

    lazy var titleLabel = UILabel()
    lazy var roundedView = RoundedView()
    lazy var addressLabel = UILabel()
    
    init(route: RouteTestData.Route) {
        super.init(frame: .zero)
        
        setupView()
        setupConstraints()
        configure(route: route)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        let font: UIFont = .systemFont(ofSize: 15)
        
        titleLabel.textColor = .black
        titleLabel.font = font
        titleLabel.textAlignment = .center
        titleLabel.minimumScaleFactor = 0.7
        
        roundedView.backgroundColor = .init(red: 217, green: 217, blue: 217)
        
        addressLabel.textColor = .init(red: 126, green: 126, blue: 126)
        addressLabel.font = font
        
        self.addSubview(titleLabel)
        self.addSubview(roundedView)
        self.addSubview(addressLabel)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.heightAnchor.constraint(equalTo: addressLabel.heightAnchor),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.08),
            
            roundedView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            roundedView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            roundedView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            roundedView.widthAnchor.constraint(equalToConstant: 2),
            
            addressLabel.topAnchor.constraint(equalTo: self.topAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            addressLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85)
        ])
    }
    
    private func configure(route: RouteTestData.Route) {
        titleLabel.text = route.mode.title
        addressLabel.text = route.address
        
        roundedView.isHidden = route.mode == .end
    }
}
