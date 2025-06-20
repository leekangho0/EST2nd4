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
    
    var routeInfos = [RouteInfo]() {
        didSet {
            DispatchQueue.main.async {
                self.routeInfoTableView.reloadData()
            }
        }
    }
    var selectedTransport: Transport?
    var dragDelegate: DraggableHeaderViewDelegate?
    var delegate: RouteDetailViewControllerDelegate?
    var warningMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /// RouteInfoTableViewCell viewHeight을 반환합니다.
    func viewHeight() -> CGFloat {
        view.layoutIfNeeded()
        
        // 상단 여백과 하단 여백을 먼저 더함
        var height = routeInfoTableViewTopConstraint.constant
        height += routeInfoTableViewBottomCosntraint.constant
        
        // routeInfoTableView의 셀 높이를 더함
        let lastIndex = min(1, routeInfos.count)
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
        return routeInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RouteInfoTableViewCell.self)) as? RouteInfoTableViewCell else { return UITableViewCell()  }
        
        let routeInfo = routeInfos[indexPath.row]
        let isLastIndex = indexPath.row == routeInfos.count - 1
        let isTransit = selectedTransport == .transit
        
        if routeInfos.count == 1, let warningMessage {
            cell.configure(warningMessage)
        } else {
            cell.configure(
                routeInfo,
                isLastIndex: isLastIndex,
                isTransit: isTransit
            )
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RouteDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == routeInfos.count - 1 {
            // 구분선 제외, 348:72 비율 적용
            return self.routeInfoTableView.frame.width * 0.2
        } else {
            // 348:88 비율 적용
            return self.routeInfoTableView.frame.width * 0.25
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if routeInfos.count == 1, warningMessage != nil { return }
        
        let storyboard = UIStoryboard(name: "RouteFinding", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TransitDetailViewController.self)) as? TransitDetailViewController else { return }
        vc.dragDelegate = self
        vc.routeInfo = routeInfos[indexPath.row]
        
        delegate?.routeDetailViewController(didSelectCellAt: indexPath.row)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: DraggableHeaderViewDelegate
extension RouteDetailViewController: DraggableHeaderViewDelegate {
    func draggableHeaderView(_ headerView: UIView, gesture: UIPanGestureRecognizer) {
        dragDelegate?.draggableHeaderView(headerView, gesture: gesture)
    }
}
