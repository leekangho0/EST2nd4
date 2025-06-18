//
//  ScheduleMainViewController.swift
//  JejuTripAppTutorial
//
//  Created by 고재현 on 6/8/25.
//

import UIKit


class ScheduleMainViewController: UIViewController {
    
    @IBOutlet var toggleButtons: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dateLabel: UILabel!
    private let sectionHeight: CGFloat = 50
    
    private var isEditMode = false
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: ScheduleViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        viewModel.bind { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onTravelChanged = { [weak self] change in
            switch change {
            case let .date(travelRange):
                self?.dateLabel.text = travelRange
            case let .title(text):
                self?.titleLabel.text = text
            default: break
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.notify()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.hasStartFlight() && viewModel.hasEndFlight() {
            toggleButtons.first?.isHidden = true
        } else {
            toggleButtons.first?.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateTableViewHeight()
    }
}

// MARK: - Actions
extension ScheduleMainViewController {
    @objc func mapButtonTapped() {
        let mapVC = FeatureFactory.makeMap(TravelPlanMapViewModel(travel: viewModel.travel))
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func toggleButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.backgroundColor = UIColor(named: "JejuOrange")
            sender.tintColor = .white
        } else {
            sender.backgroundColor = UIColor(hex: "#D9D9D9", alpha: 0.6)
            sender.tintColor = UIColor(hex: "#7E7E7E", alpha: 1.0)
        }
    }
    
    @objc func addPlaceButtonTapped(_ sender: UIButton) {
        let section = sender.tag
        let searchVC = FeatureFactory.makeSearch(section: section)
        
        searchVC.delegate = self  // 꼭 delegate 지정
        self.navigationController?.pushViewController(searchVC, animated: true)
        
        updateTableViewHeight()
    }
    
    @IBAction func addFlight(_ sender: Any) {
        let flightVC = FeatureFactory.makeFlight(travel: viewModel.travel)
        flightVC.mode = .append
        flightVC.dateType = viewModel.hasStartFlight() ? .end : (viewModel.hasEndFlight() ? .start : .all)
        flightVC.onUpdate = { [weak self] dateType, flight in
            guard let self else { return }
            
            if dateType == .start {
                self.viewModel.updateStartFlight(flight: flight)
            } else {
                self.viewModel.updateEndFlight(flight: flight)
            }
        }
        
        CalendarSelectionStore.shared.setTravelDate(
            TravelDate(
                startDate: viewModel.startDate,
                endDate: viewModel.endDate
            )
        )
        
        self.navigationController?.pushViewController(flightVC, animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Schedule", bundle: nil)
        guard let editVC = storyboard.instantiateViewController(withIdentifier: "EditMenuViewController") as? EditMenuViewController else {
            return
        }
        editVC.delegate = self
        
        // 모달 시트 스타일 설정
        if let sheet = editVC.sheetPresentationController {
            sheet.detents = [.custom { _ in 280 }]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 20
        }
        
        present(editVC, animated: true)
        
    }
    
    @IBAction func handleLongPress(_ gesture: UILongPressGestureRecognizer? = nil) {
        if let state = gesture?.state {
            if state == .ended {
                updateEditMode()
            }
        }
    }
    
    private func updateEditMode() {
        isEditMode.toggle()
        tableView.isEditing = isEditMode
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Set up UI
extension ScheduleMainViewController {
    private func setupView() {
        self.titleLabel.text = viewModel.title
        self.dateLabel.text = viewModel.dateRangeTitle
        setNavigation()
        setTableView()
        
        toggleButtons.forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
//            button.layer.backgroundColor = UIColor(hex: "#D9D9D9", alpha: 0.6)?.cgColor
//            button.setTitleColor(UIColor(hex: "#7E7E7E", alpha: 1.0), for: .normal)
        }
    }
    
    private func setNavigation() {
        navigationController?.navigationBar.tintColor = .label
        
        let mapButton = UIBarButtonItem(
            image: UIImage(systemName: "map"),
            style: .plain,
            target: self,
            action: #selector(mapButtonTapped)
        )
        navigationItem.rightBarButtonItem = mapButton
        
        let leftButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = leftButton
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        
        toggleButtons.forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
            
            if traitCollection.userInterfaceStyle == .dark {
                button.backgroundColor = UIColor(named: "DolHareubangLightGray")
                button.setTitleColor(UIColor(named: "DolHareubangGray"), for: .normal)
                button.tintColor = UIColor(named: "DolHareubangGray")
            } else {
                button.backgroundColor = UIColor(named: "DolHareubangLightGray")
                button.setTitleColor(UIColor(named: "DolHareubangGray"), for: .normal)
                button.tintColor = UIColor(named: "DolHareubangGray")
            }
            
        }
        
        tableView.separatorStyle = .none
//        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func updateTableViewHeight() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }
    
    private func isStartFlightCell(at indexPath: IndexPath) -> Bool {
        return isStartFlightSection(indexPath.section) && indexPath.row == 0
    }
    
    private func isStartFlightSection(_ section: Int) -> Bool {
        return viewModel.hasStartFlight() && section == 0
    }
    
    private func isEndFlightCell(at indexPath: IndexPath) -> Bool {
        return isEndFlightSection(indexPath.section) && viewModel.isLastIndex(indexPath.section, indexPath.row - 1)
    }
    
    private func isEndFlightSection(_ section: Int) -> Bool {
        return viewModel.hasEndFlight() && viewModel.isLastSection(section)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ScheduleMainViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = viewModel.numberOfRowsInSection(section: section)
        
        // 항공편 정보가 있을 경우 해당 section 내에서 1 추가
        if isStartFlightSection(section) || isEndFlightSection(section){ count += 1 }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ScheduleListCell.self), for: indexPath) as! ScheduleListCell
        
        let section = indexPath.section
        var index = indexPath.row
        
        if isStartFlightCell(at: indexPath) {
            if let startFlightAirport = viewModel.startFlightAirport,
               let startFlightTime = viewModel.startFlightArrivalTime {
                cell.configure(
                    indexPath: indexPath,
                    airport: startFlightAirport,
                    time: startFlightTime
                )
            }
        } else if isEndFlightCell(at: indexPath) {
            if let endFlightAirport = viewModel.endFlightAirport,
               let endFlightTime = viewModel.endFlightDepartureTime {
                
                cell.configure(
                    indexPath: indexPath,
                    airport: endFlightAirport,
                    time: endFlightTime
                )
            }
        } else {
            
            if isStartFlightSection(section) {
                index -= 1
            }
            
            let place = viewModel.place(section: section, index: index)
            cell.configure(indexPath: indexPath, place: place)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ScheduleListHeaderView()
        
        headerView.dayLabel.text = "Day \(section + 1)"
        headerView.dateLabel.text = viewModel.headerTitle(section: section)
        headerView.addPlaceButton.tag = section

        headerView.dateLabel.text = viewModel.dateToString(section: section)
        
        /*
        headerView.editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        headerView.editButton.setTitle(nil, for: .normal)
        
        headerView.addPlaceButton.setTitle("장소 추가", for: .normal)
        headerView.addMemoButton.setTitle("메모 추가", for: .normal)
        */
        
        headerView.addPlaceButton.tag = section
        headerView.addPlaceButton.isHidden = isEditMode
        headerView.addPlaceButton.addTarget(self, action: #selector(addPlaceButtonTapped(_:)), for: .touchUpInside)
        
        headerView.editConfirmButton.isHidden = !isEditMode
        headerView.endEdit = { [weak self] in
            self?.updateEditMode()
        }
        
        return headerView
    }
    
    // 편집
    // 편집 모드에서 셀 왼쪽에 여백 방지
    func tableView(_ tableView: UITableView,
                   shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if isStartFlightCell(at: indexPath) || isEndFlightCell(at: indexPath) { return false }
        
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        
        viewModel.movePlace(sourceIndexPath, destinationIndexPath)
        let indices = IndexSet(arrayLiteral: sourceIndexPath.section, destinationIndexPath.section)
        tableView.performBatchUpdates { [self] in
            self.tableView.reloadSections(indices, with: .automatic)
        }
    }
    
    // 삭제
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if isStartFlightCell(at: indexPath) || isEndFlightCell(at: indexPath) { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completion in
            
            guard let self else { return }
            
            var index = indexPath.row
            
            if self.isStartFlightSection(indexPath.section) {
                index -= 1
            }
            
            self.viewModel.removePlace(indexPath.section, index)
            self.tableView.performBatchUpdates {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } completion: { _ in
                self.tableView.reloadData()
            }
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - UITableViewDelegate
extension ScheduleMainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.sectionHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isStartFlightCell(at: indexPath) || isEndFlightCell(at: indexPath) {
            let flightVC = FeatureFactory.makeFlight(travel: viewModel.travel)
            flightVC.mode = .edit
            flightVC.dateType = isStartFlightCell(at: indexPath) ? .start : .end
            flightVC.existingFlight = isStartFlightCell(at: indexPath) ? viewModel.startFlight : viewModel.endFlight
            flightVC.onUpdate = { [weak self] _, flight in
                guard let self else { return }
                
                if flightVC.dateType == .start {
                    self.viewModel.updateStartFlight(flight: flight)
                } else {
                    self.viewModel.updateEndFlight(flight: flight)
                }
            }
            flightVC.onDelete = { [weak self] in
                guard let self else { return }
                
                if flightVC.dateType == .start {
                    self.viewModel.deleteStartFlight()
                } else {
                    self.viewModel.deleteEndFlight()
                }
            }
            
            self.navigationController?.pushViewController(flightVC, animated: true)
        } else {
            let section = indexPath.section
            var index = indexPath.row
            
            if isStartFlightSection(section) {
                index -= 1
            }
            
            let detailVC = FeatureFactory.makeScheduleDetail()
            detailVC.modalPresentationStyle = .pageSheet
            detailVC.delegate = self
            detailVC.place = viewModel.place(section: section, index: index)
            detailVC.section = section
            
            self.present(detailVC, animated: true)
        }
    }
}

// MARK: - ScheduleDetailViewControllerDelegate
extension ScheduleMainViewController: ScheduleDetailViewControllerDelegate {
    func updatePlaceDate(section: Int, place: PlaceEntity?, date: Date) {
        if let id = place?.id {
            viewModel.updatePlaceTime(in: section, placeID: id, time: date)
        }
    }
    
    func updatePlaceMemo(section: Int, place: PlaceEntity?, memo: String) {
        if let id = place?.id {
            viewModel.updatePlaceMemo(in: section, placeID: id, memo: memo)
        }
    }
    
    func didTapRouteFindingButton(place: PlaceEntity?) {
        let routeFindingVC = FeatureFactory.makeRoute()
        routeFindingVC.place = place
        
        self.navigationController?.pushViewController(routeFindingVC, animated: true)
    }
}

// MARK: - SearchViewControllerDelegate
extension ScheduleMainViewController: SearchViewControllerDelegate {
    func searchViewController(_ controller: SearchViewController, place: PlaceDTO, for section: Int) {
        viewModel.addPlace(place, section)
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        updateTableViewHeight()
    }
    
    func searchViewController(_ controller: SearchViewController, place: GooglePlaceDTO, for section: Int) {
        viewModel.addPlace(place, section)
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        updateTableViewHeight()
    }
    
    func searchViewController(_ controller: SearchViewController, didSelectPlace place: PlaceDTO, for section: Int) {
        viewModel.addPlace(place, section)
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        updateTableViewHeight()
    }
}

// MARK: - EditMenuViewControllerDelegate
extension ScheduleMainViewController: EditMenuViewControllerDelegate {
    func didUpdateTitle(_ newTitle: String) {
        viewModel.updateTitle(newTitle)
    }
    
    func didUpdateDate() {
        let calendarVC = FeatureFactory.makeCalendar()
        calendarVC.isEditMode = true
        calendarVC.completion = { [weak self] startDate, endDate in
            guard let self else { return }
 
            if let startDate, let endDate {
                self.viewModel.updateDate(start: startDate, end: endDate)
            }
        }
        
        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    func didDeleteTravel() {
        viewModel.delteTravel()
        backButtonTapped()
    }
}
