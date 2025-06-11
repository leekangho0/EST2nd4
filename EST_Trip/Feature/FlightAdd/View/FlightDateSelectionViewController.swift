//
//  FlightDateSelectionViewController.swift
//  EST_Trip
//
//  Created by hyunMac on 6/11/25.
//

import UIKit

class FlightDateSelectionViewController: UIViewController {
    var onSelectDepartureDate: ((Date) -> Void)?
    var viewModel: FlightAddViewModel!
    var travelDate: TravelDate {
        //테스팅용 임시 데이터, 캘린더와 추후 연결 필요
        let firstDate = Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        let secondDate = Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? Date()
        CalendarSelectionManager.shared.select(date: firstDate)
        CalendarSelectionManager.shared.select(date: secondDate)
        print("travelDate 체크 \(CalendarSelectionManager.shared.travelDate)")
        return CalendarSelectionManager.shared.travelDate
    }

    @IBOutlet weak var firstDateButton: UIButton!
    @IBAction func firstDateButtonTapped(_ sender: Any) {
        let date = travelDate.startDate ?? Date()
        viewModel.flight.departureDate = date
        viewModel.flight.arrivalAirport = "제주국제공항"
		onSelectDepartureDate?(date)
        dismiss(animated: true)
    }

    @IBOutlet weak var secondDateButton: UIButton!
    @IBAction func secondDateButtonTapped(_ sender: Any) {
        let date = travelDate.endDate ?? Date()
        viewModel.flight.departureDate = date
        viewModel.flight.departureAirport = "제주국제공항"
        onSelectDepartureDate?(date)
        dismiss(animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let sheet = self.sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in return 196 })]
            sheet.preferredCornerRadius = 16
        }

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
