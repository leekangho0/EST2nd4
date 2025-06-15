//
//  WalkStepView.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/12/25.
//

import UIKit

class WalkStepView: UIView {
    
    lazy var imageView = UIImageView()
    lazy var roundedView = RoundedView()
    lazy var durationLabel = UILabel()
    
    init(route: RouteInfo.Route) {
        super.init(frame: .zero)
        
        setupView()
        configure(duration: route.durationText())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        imageView.image = .init(systemName: "figure.walk")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        
        roundedView.backgroundColor = .init(red: 217, green: 217, blue: 217)
        
        durationLabel.textColor = .init(red: 126, green: 126, blue: 126)
        durationLabel.font = .systemFont(ofSize: 15)
        
        self.addSubview(imageView)
        self.addSubview(roundedView)
        self.addSubview(durationLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.08),
            imageView.heightAnchor.constraint(equalTo: durationLabel.heightAnchor),
            
            roundedView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            roundedView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            roundedView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            roundedView.widthAnchor.constraint(equalToConstant: 2),
            
            durationLabel.topAnchor.constraint(equalTo: self.topAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            durationLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85)
        ])
    }
    
    private func configure(duration: String) {
        durationLabel.text = "도보 \(duration)"
    }
}
