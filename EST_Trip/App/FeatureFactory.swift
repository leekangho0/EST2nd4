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
    
    static func makePlanner() -> ScheduleMainViewController {
        let vc = StoryboardType.schedule.makeViewController(ScheduleMainViewController.self)
        return vc
    }

    static func makeRoute() -> RouteFindingViewController {
        let vc = StoryboardType.route.makeViewController(RouteFindingViewController.self)
        
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
    
    static func makeMap(_ viewModel: TravelPlanMapViewModel) -> TravelPlanMapViewController {
        let vc = StoryboardType.map.makeViewController(TravelPlanMapViewController.self)
        vc.viewModel = viewModel
        return vc
    }
        static func makePlanMap() -> PlanSheetViewController {
        StoryboardType.map.makeViewController(PlanSheetViewController.self)

    }
    static func makeScheduleDetail() -> ScheduleDetailViewController {
        let vc = StoryboardType.scheduleDetail.makeViewController(ScheduleDetailViewController.self)
        return vc
    }
}
