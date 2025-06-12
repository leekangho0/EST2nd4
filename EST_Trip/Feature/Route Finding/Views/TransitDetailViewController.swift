//
//  TransitDetailViewController.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/12/25.
//

import UIKit

class TransitDetailViewController: UIViewController {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var walkDurationLabel: UILabel!
    @IBOutlet weak var fareLabel: UILabel!
    
    @IBOutlet weak var routeStepsTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    private func configure() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
