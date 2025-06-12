//
//  FlightAddViewController.swift
//  EST_Trip
//
//  Created by hyunMac on 6/10/25.
//

import UIKit

class FlightAddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let leftButton = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let chevronImage = UIImage(systemName: "chevron.left", withConfiguration: config)
        leftButton.setImage(chevronImage, for: .normal)
        leftButton.tintColor = .label
        
        leftButton.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        let customLeftBarButton = UIBarButtonItem(customView: leftButton)
        navigationItem.leftBarButtonItem = customLeftBarButton
        
        let titleView = FlightAddNavigationTitleView()
        titleView.titleLabel.text = "항공편 추가"
        titleView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
        navigationItem.titleView = titleView

        let rightButton = UIButton(type: .system)
        rightButton.setTitle("완료", for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        let customRightBarButton = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = customRightBarButton
        
        rightButton.addTarget(self, action: #selector(completeTap), for: .touchUpInside)

    }
}

extension FlightAddViewController {
    @objc func completeTap(_ sender: Any) {
        let vc = FeatureFactory.makePlanner()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
