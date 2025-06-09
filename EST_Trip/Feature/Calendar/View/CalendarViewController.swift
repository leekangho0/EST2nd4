//
//  CalendarViewController.swift
//  EST_Trip
//
//  Created by hyunMac on 6/9/25.
//

import UIKit

final class CalendarViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var setDateButton: UIButton!
    @IBOutlet weak var dateSelectionView: UIView!

    private let calendarManager = CalendarManager()
    private let calendarSelectionManager = CalendarSelectionManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        dateSelectionView.layer.shadowColor = UIColor.black.cgColor
        dateSelectionView.layer.shadowOpacity = 0.1

        collectionView.dataSource = self
        collectionView.delegate = self

        print("뷰디드로드 됨")
        print("컬렉션뷰 프레임:", collectionView.frame)
        print("섹션 데이터 개수:", calendarManager.dates(for: 0).count)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let todayIndexPath = calendarManager.todayIndexPath {
            collectionView.scrollToItem(at: todayIndexPath, at: .centeredVertically, animated: false)
        }
    }

    func updateDateSelectionUI() {
        let travelDate = calendarSelectionManager.travelDate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.M.d"

        if let start = travelDate.startDate, let end = travelDate.endDate {
            let startText = formatter.string(from: start)
            let endFormatter = DateFormatter()
            endFormatter.dateFormat = "M.d"
            let endText = endFormatter.string(from: end)

            let fullText = "\(startText) - \(endText) / 등록 완료"
            let attributed = NSAttributedString(string: fullText, attributes: [
                .font: UIFont.systemFont(ofSize: 13, weight: .bold),
                .foregroundColor: UIColor.white
            ])
            setDateButton.setAttributedTitle(attributed, for: .normal)
            dateSelectionView.isHidden = false
        } else if let start = travelDate.startDate {
            let startText = formatter.string(from: start)
            let fullText = "\(startText) / 당일 일정으로 등록완료"
            let attributed = NSAttributedString(string: fullText, attributes: [
                .font: UIFont.systemFont(ofSize: 13, weight: .bold),
                .foregroundColor: UIColor.white
            ])
            setDateButton.setAttributedTitle(attributed, for: .normal)
            dateSelectionView.isHidden = false
        } else {
            dateSelectionView.isHidden = true
        }
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return calendarManager.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = calendarManager.dates(for: section).count
        print("섹션 \(section)의 셀 개수: \(count)")
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("셀 그리기 디버깅")

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCell else {
            fatalError("DeteCell 못 불러옴 에러")
        }

        let dateModel = calendarManager.dates(for: indexPath.section)[indexPath.item]

        if dateModel.date == .distantPast {
            cell.configure(dateText: "",
                           subtitleText: nil,
                           isToday: false,
                           isWeekend: false,
                           isSelected: false,
                           isInRange: false)
            return cell
        }

        let date = dateModel.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let dateString = dateFormatter.string(from: date)

        let isToday = Calendar.current.isDateInToday(date)
        let weekday = Calendar.current.component(.weekday, from: date)

        let isWeekend: Bool
        if dateModel.date == .distantPast {
            isWeekend = false
        } else {
            let w = Calendar.current.component(.weekday, from: dateModel.date)
            isWeekend = w == 1 || w == 7
        }

        let isSelected = calendarSelectionManager.isStartOrEndDate(date)
        let isInRange = calendarSelectionManager.isInSelectedRange(date)

        cell.configure(
            dateText: dateString,
            subtitleText: dateModel.annotation,
            isToday: isToday,
            isWeekend: isWeekend,
            isSelected: isSelected,
            isInRange: isInRange
        )
        return cell
    }

}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {

    //셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = calendarManager.dates(for: indexPath.section)[indexPath.item]

        guard model.date != .distantPast else { return }

        calendarSelectionManager.select(date: model.date)
        collectionView.reloadData()
        updateDateSelectionUI()
    }

    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 0
        let width = (collectionView.bounds.width - totalSpacing) / 7
        return CGSize(width: floor(width), height: floor(width))
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CalendarHeaderView", for: indexPath) as! CalendarHeaderView

        header.configure(title: calendarManager.title(for: indexPath.section))
        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: collectionView.bounds.width, height: 100)
    }
}
