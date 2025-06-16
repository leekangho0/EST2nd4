//
//  UIStoryboard+Util.swift
//  EST_Trip
//
//  Created by kangho lee on 6/11/25.
//

import UIKit

enum StoryboardType: String {
    case main = "Main"
    case flight = "FlightAdd"
    case calendar = "Calendar"
    case schedule = "Schedule"
    case route = "RouteFinding"
    case search = "Search"
    case map = "Map"
    case scheduleDetail = "ScheduleDetail"
}

extension StoryboardType {
    func makeViewController<T: UIViewController>(_ type: T.Type) -> T {
        UIStoryboard.instantiate(from: self.rawValue, bundle: nil)
    }
}

extension UIStoryboard {
    static func instantiate<T: UIViewController>(
        from name: String,
        bundle: Bundle? = nil
    ) -> T {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        let identifier = String(describing: T.self)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Failed instantatiate")
        }
        
        return vc
    }
}
