//
//  RouteDetailViewController.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/11/25.
//

import UIKit

class RouteDetailViewController: UIViewController {

    @IBOutlet weak var draggableHeaderView: UIView!
    @IBOutlet weak var routeInfoTableView: UITableView!
    @IBOutlet weak var routeInfoTableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var routeInfoTableViewBottomCosntraint: NSLayoutConstraint!
    
    struct TestData {
        let duration: Int
        let distance: Double
        var walkDuration: Int = 0
        var taxiFare: Int = 0
        let fare: Int
    }
    
    let testDatas = [
        TestData(duration: 69, distance: 82.5, taxiFare: 25600, fare: 20034),
        TestData(duration: 30, distance: 82.5, taxiFare: 25600, fare: 20034),
        TestData(duration: 10, distance: 82.5, taxiFare: 25600, fare: 20034),
        TestData(duration: 34, distance: 82.5, taxiFare: 25600, fare: 20034),
        TestData(duration: 120, distance: 82.5, taxiFare: 25600, fare: 20034)
    ]
    
    var selectedTransport: Transport? {
        didSet {
            guard isViewLoaded else { return }
            routeInfoTableView.reloadData()
        }
    }
    var dragDelegate: DraggableHeaderViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /// RouteInfoTableViewCell 개수에 따른 viewHeight을 반환합니다.
    func viewHeight(forRouteInfoCount count: Int) -> CGFloat {
        view.layoutIfNeeded()
        
        // 상단 여백과 하단 여백을 먼저 더함
        var height = routeInfoTableViewTopConstraint.constant
        height += routeInfoTableViewBottomCosntraint.constant
        
        // routeInfoTableView의 셀 높이를 더함
        let lastIndex = min(count, testDatas.count)
        for index in 0..<lastIndex {
            height += routeInfoTableView.rectForRow(at: IndexPath(row: index, section: 0)).height
        }
        
        return height
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        dragDelegate?.draggableHeaderView(draggableHeaderView, gesture: gesture)
    }
}

// MARK: - UITableViewDataSource
extension RouteDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RouteInfoTableViewCell.self)) as? RouteInfoTableViewCell else { return UITableViewCell()  }
        
        let data = testDatas[indexPath.row]
        
        cell.durationLabel.text = "\(data.duration)분"
        cell.distanceLabel.text = "\(data.distance)km"
        cell.taxiFareLabel.text = "택시 요금 약 \(data.taxiFare)원"
        cell.fareLabel.text = "운행 요금 약 \(data.fare)원"
        cell.seperatorView.isHidden = indexPath.row == testDatas.count - 1
        
        if let selectedTransport {
            let isTransit = selectedTransport == .transit
            cell.findRouteButton.isHidden = isTransit
            cell.selectButton.isHidden = !isTransit
        }
        
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RouteDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == testDatas.count - 1 {
            // 구분선 제외, 348:72 비율 적용
            return self.routeInfoTableView.frame.width * 0.2
        } else {
            // 348:88 비율 적용
            return self.routeInfoTableView.frame.width * 0.25
        }
    }
}

// MARK: - RouteInfoTableViewCellDelegate
extension RouteDetailViewController: RouteInfoTableViewCellDelegate {
    func didTapSelectButton() {
        let storyboard = UIStoryboard(name: "RouteFinding", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TransitDetailViewController.self)) as? TransitDetailViewController else { return }
        vc.dragDelegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: DraggableHeaderViewDelegate
extension RouteDetailViewController: DraggableHeaderViewDelegate {
    func draggableHeaderView(_ headerView: UIView, gesture: UIPanGestureRecognizer) {
        dragDelegate?.draggableHeaderView(headerView, gesture: gesture)
    }
}
