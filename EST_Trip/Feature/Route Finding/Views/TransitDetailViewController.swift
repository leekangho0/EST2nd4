//
//  TransitDetailViewController.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/12/25.
//

import UIKit

class TransitDetailViewController: UIViewController {

    @IBOutlet weak var draggableHeaderView: UIView!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var walkDurationLabel: UILabel!
    @IBOutlet weak var fareLabel: UILabel!
    
    @IBOutlet weak var routeStepStackView: UIStackView!
    @IBOutlet weak var routeStepStackViewHeightCosntraint: NSLayoutConstraint!
    
    private var stepViewHeightConstraints = [NSLayoutConstraint]()
    
    var dragDelegate: DraggableHeaderViewDelegate?
    
    var routeInfo: RouteInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureRouteStepStackView()
    }

    private func setupView() {
        self.navigationController?.isNavigationBarHidden = true
        
        guard let routeInfo else { return }
        
        durationLabel.text = routeInfo.durationText()
        distanceLabel.text = routeInfo.distanceText()
        walkDurationLabel.text = routeInfo.walkDurationText()
        fareLabel.text = routeInfo.fareText()
    }
    
    private func configureRouteStepStackView() {
        guard let routeInfo, let routes = routeInfo.routes else { return }
                
        stepViewHeightConstraints = []
        
        var totalHeight: CGFloat = 0
        
        routes.forEach { route in
            let stepView = createStepView(route: route)
                    
            stepView.translatesAutoresizingMaskIntoConstraints = false

            let stepViewHeight = stepViewHeight(mode: route.mode)
            let heightConstraint = stepView.heightAnchor.constraint(equalToConstant: stepViewHeight)
            totalHeight += stepViewHeight
            
            heightConstraint.isActive = true
            stepViewHeightConstraints.append(heightConstraint)
            
            routeStepStackView.addArrangedSubview(stepView)
        }
        
        self.routeStepStackViewHeightCosntraint.constant = totalHeight
    }
    
    private func createStepView(route: RouteInfo.Route) -> UIView {
        switch route.mode {
        case .start, .end, .alighting:
            let stepView = LocationStepView(route: route)
            
            return stepView
        case .walk:
            let stepView = WalkStepView(route: route)
            
            return stepView
        case .boarding:
            let stepView = BusStepView(route: route)
            stepView.delegate = self
            stepView.index = stepViewHeightConstraints.count
            
            return stepView
        }
    }
    
    private func stepViewHeight(mode: RouteInfo.Mode) -> CGFloat {
        return routeStepStackView.bounds.width * 0.15
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        dragDelegate?.draggableHeaderView(draggableHeaderView, gesture: gesture)
    }
}

// MARK: - BusStepViewDelegate
extension TransitDetailViewController: BusStepViewDelegate {
    func didUpdateHeight(index: Int, height: CGFloat) {
        DispatchQueue.main.async {
            let oldHeight = self.stepViewHeightConstraints[index].constant
            let newHeight = height
            
            self.stepViewHeightConstraints[index].constant = newHeight
            
            self.routeStepStackViewHeightCosntraint.constant += (newHeight - oldHeight)
        }
    }
}
