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

	private let viewModel = CalendarViewModel()
    private var didScrollToToday = false

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        dateSelectionView.layer.shadowColor = UIColor.black.cgColor
        dateSelectionView.layer.shadowOpacity = 0.1
        dateSelectionView.isHidden = true
        
        setDateButton.addTarget(self, action: #selector(dateButtonTap), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.resetSelection()
        collectionView.reloadData()
        didScrollToToday = false
        updateDateSelectionUI()
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        guard !didScrollToToday, let indexPath = viewModel.todayIndexPath else { return }

        collectionView.performBatchUpdates(nil) { [weak self] _ in
            self?.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            self?.didScrollToToday = true
        }
    }

    func updateDateSelectionUI() {
        let travelDate = viewModel.travelDate
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy.M.d"
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "M.d"

        if let start = travelDate.startDate, let end = travelDate.endDate {
            let startText = formatter1.string(from: start)
            let endText = formatter2.string(from: end)
            let fullText = "\(startText) - \(endText) / 등록 완료"

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
        return viewModel.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.dates(for: section).count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.dates(for: indexPath.section)[indexPath.item]

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCell else {
            fatalError("DeteCell 못 불러옴 에러")
        }

        if model.date == .distantPast {
            cell.configure(dateText: "",
                           subtitleText: nil,
                           isToday: false,
                           isWeekend: false,
                           isSelected: false,
                           isInRange: false)
            return cell
        }

        let date = model.date
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let dateString = formatter.string(from: date)

        cell.configure(
            dateText: dateString,
            subtitleText: model.annotation,
            isToday: viewModel.isToday(model.date),
            isWeekend: viewModel.isWeekend(model.date),
            isSelected: viewModel.isStartOrEndDate(model.date),
            isInRange: viewModel.isInSelectedRange(model.date)
        )
        return cell
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    //셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModel.dates(for: indexPath.section)[indexPath.item]
        guard model.date != .distantPast else { return }

        viewModel.select(date: model.date)
        collectionView.reloadData()
        updateDateSelectionUI()
    }

    // 간격, 셀 크기
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 7
        return CGSize(width: floor(width), height: floor(width))
    }

    // 헤더 그대로
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CalendarHeaderView", for: indexPath) as! CalendarHeaderView

        header.configure(title: viewModel.title(for: indexPath.section))
        return header
    }
}

extension CalendarViewController {
    @objc func dateButtonTap(_ sender: Any) {
        let vc = FeatureFactory.makeFlight()
        
        let travle = Travel(
            startDate: viewModel.travelDate.startDate,
            endDate: viewModel.travelDate.endDate
        )
        vc.travel = travle

        
        navigationController?.pushViewController(vc, animated: true)
    }
}
