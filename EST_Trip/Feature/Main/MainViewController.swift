//
//  MainViewController.swift
//  EST_Trip
//
//  Created by kangho lee on 6/12/25.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBAction func buttonTap(_ sender: Any) {
        let vc = FeatureFactory.makeCalendar()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController {
    
}
