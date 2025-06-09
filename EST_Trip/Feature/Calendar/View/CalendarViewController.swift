//
//  CalendarViewController.swift
//  EST_Trip
//
//  Created by hyunMac on 6/9/25.
//

import UIKit

final class CalendarViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private let calendarManager = CalendarManager()
    private let calendarSelectionManager = CalendarSelectionManager()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
