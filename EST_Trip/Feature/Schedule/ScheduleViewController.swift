//
//  ScheduleViewController.swift
//  EST_Trip
//
//  Created by kangho lee on 6/12/25.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(onMap))
    }
    
}

extension ScheduleViewController {
    @IBAction func onAddPlace(_ sender: Any) {
        let vc = FeatureFactory.makeSearch()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onRoute(_ sender: Any) {
        
        let vc = FeatureFactory.makeRoute()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onMap(_ sender: Any) {
        let vc = FeatureFactory.makeMap(TravelPlanMapViewModel(travel: TravelEntity.sample(context: CoreDataManager.shared.context)))
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
