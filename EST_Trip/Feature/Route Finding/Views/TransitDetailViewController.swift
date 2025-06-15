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
    
    var testData: RouteDetailViewController.TestData?
    var routes: [RouteTestData.Route] = [
        .init(mode: .start, address: "제주시 애월읍"),
        .init(mode: .walk, duration: 10),
        .init(
            mode: .boarding,
            stop: .init(
                departureName: "강남역 2번출구",
                destinationName: "논현역",
                intermediateStops: [
                    "강남역 1",
                    "강남역 2",
                    "강남역 2",
                    "강남역 3",
                    "강남역 4",
                ],
                busInfos: [
                    .init(name: "333", color: .green),
                    .init(name: "155", color: .yellow),
                    .init(name: "1534", color: .red),
                    .init(name: "1534", color: .black),
                    .init(name: "256", color: .blue),
                    .init(name: "3233", color: .orange),
                    .init(name: "333 간선", color: .green),
                    .init(name: "333 지선", color: .orange),
                    .init(name: "33", color: .green),
                    .init(name: "3", color: .green),
                    .init(name: "33", color: .green),
                    .init(name: "10", color: .orange),
                    .init(name: "21", color: .green),
                ]
            )
        ),
        .init(mode: .alighting, address: "ddddd"),
        .init(mode: .walk, duration: 20),
        .init(mode: .end, address: "제주시 애월읍"),
    ]
    var dragDelegate: DraggableHeaderViewDelegate?
    
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
        
        guard let testData else { return }
        
        durationLabel.text = "\(testData.duration)분"
        distanceLabel.text = "\(testData.distance)km"
        walkDurationLabel.text = "도보이동 \(testData.walkDuration)분"
        fareLabel.text = "총 요금 \(testData.fare)원"
    }
    
    private func configureRouteStepStackView() {
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
    
    private func createStepView(route: RouteTestData.Route) -> UIView {
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
    
    private func stepViewHeight(mode: RouteTestData.Mode) -> CGFloat {
        let scale = mode == .walk ? 0.15 : 0.13
        return routeStepStackView.bounds.width * scale
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
