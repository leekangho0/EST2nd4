//
//  FeatureFactory.swift
//  EST_Trip
//
//  Created by kangho lee on 6/11/25.
//

import UIKit

enum FeatureFactory {
    static func makeMain() -> MainViewController {
        let vc = StoryboardType.main.makeViewController(MainViewController.self)
        return vc
    }
    
    static func makeCalendar() -> CalendarViewController {
        let vc = StoryboardType.calendar.makeViewController(CalendarViewController.self)
        return vc
    }
    
    static func makeFlight() -> FlightAddViewController {
        let vc = StoryboardType.flight.makeViewController(FlightAddViewController.self)
        return vc
    }
    
    static func makePlanner() -> ScheduleViewController {
        let vc = StoryboardType.schedule.makeViewController(ScheduleViewController.self)
        return vc
    }
    
    static func makeRoute() -> RouteViewController {
        let vc = StoryboardType.route.makeViewController(RouteViewController.self)
        
        return vc
    }
    
    static func makeSearch() -> SearchViewController {
        let vc = StoryboardType.search.makeViewController(SearchViewController.self)
        return vc
    }

    static func makeSearchResult() -> SearchResultViewController {
        let vc = StoryboardType.search.makeViewController(SearchResultViewController.self)
        
        return vc
    }
    
    static func makeMap() -> TravelPlanMapViewController {
        let vc = StoryboardType.map.makeViewController(TravelPlanMapViewController.self)
        return vc
    }
}
