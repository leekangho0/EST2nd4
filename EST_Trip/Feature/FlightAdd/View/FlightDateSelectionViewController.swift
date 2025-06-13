//
//  FlightDateSelectionViewController.swift
//  EST_Trip
//
//  Created by hyunMac on 6/11/25.
//

import UIKit

class FlightDateSelectionViewController: UIViewController {
    var isArrivalSelection: Bool = false
    var baseDepartureDate: Date?
    var onSelectArrivalDate: ((Date) -> Void)?
    var onSelectDepartureDate: ((Date, Bool) -> Void)?
    private let selectionStore = CalendarSelectionStore.shared

    var travelDate: TravelDate {
        return selectionStore.travelDate
    }

    @IBOutlet weak var firstDateButton: UIButton!
    @IBAction func firstDateButtonTapped(_ sender: Any) {
        if isArrivalSelection {
			let arrivalDate = baseDepartureDate ?? Date()
            onSelectArrivalDate?(arrivalDate)
        } else {
            let date = travelDate.startDate ?? Date()
            onSelectDepartureDate?(date, true)
        }
        dismiss(animated: true)
    }

    @IBOutlet weak var secondDateButton: UIButton!
    @IBAction func secondDateButtonTapped(_ sender: Any) {
        if isArrivalSelection {
            let arrivalDate = Calendar.current.date(byAdding: .day, value: 1, to: baseDepartureDate ?? Date())!
            onSelectArrivalDate?(arrivalDate)
        } else {
            let date = travelDate.endDate ?? Date()
            onSelectDepartureDate?(date, false)
        }
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let sheet = self.sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in return 196 })]
            sheet.preferredCornerRadius = 16
        }

        if isArrivalSelection {
			let departureDate = baseDepartureDate ?? Date()

            let formatter = DateFormatter()
            formatter.dateFormat = "MM.dd"

            let todayStr = formatter.string(from: departureDate)
            let nextStr = formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: departureDate)!
            )

            firstDateButton.setTitle(todayStr, for: .normal)
            secondDateButton.setTitle(nextStr, for: .normal)
        } else {
            let date = travelDate
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "MM.dd / E"
            let firstFormattedStr = formatter.string(from: date.startDate ?? Date())
            firstDateButton.setTitle("가는날 선택 \(firstFormattedStr)", for: .normal)

            let SecondFormattedStr = formatter.string(from: date.endDate ?? Date())
            secondDateButton.setTitle("오는날 선택 \(SecondFormattedStr)", for: .normal)
        }
    }
}
