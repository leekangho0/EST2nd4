//
//  TravelPlanMapViewModel.swift
//  EST_Trip
//
//  Created by kangho lee on 6/17/25.
//

import Foundation
import GoogleMaps

class TravelPlanMapViewModel {
    let schedules: [ScheduleEntity]
    
    var currentMarker: [GMSMarker] = []
    
    init(travel: TravelEntity) {
        self.schedules = travel.orderedSchdules
    }
    
    func selectMarker(_ item: PlaceEntity) -> GMSMarker? {
        return currentMarker.first(where: { marker in
            marker.position.latitude == item.latitude && marker.position.longitude == item.longitude
        })
    }
    
    func drawMarkers(_ places: [PlaceEntity]) {
        self.currentMarker = places.map { place in
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            marker.title = place.name
            marker.snippet = "카페"
            return marker
        }
    }
    
    func drawPolyLine() -> (line: GMSPolyline, path: GMSPath) {
        // 경로 그리기
        let path = GMSMutablePath()
        
        currentMarker.map(\.position).forEach { position in
            path.add(CLLocationCoordinate2D(latitude: position.latitude, longitude: position.longitude))
        }

        let polyline = GMSPolyline(path: path)

        // Dash line
        let strokeStyles = [GMSStrokeStyle.solidColor(.jejuOrange), GMSStrokeStyle.solidColor(.clear)]
        let strokeLengths = [NSNumber(value: 200), NSNumber(value: 200)]
        
        polyline.spans = GMSStyleSpans(path, strokeStyles, strokeLengths, .rhumb)

        polyline.strokeWidth = 3
        
        return (polyline, path)
    }
}

struct PlaceDetail: Equatable {
    let placeID: String
    let name: String?
    let reviews: Int
    let rating: Double
    let imageURL: Data?
    let latitude: Double
    let longitude: Double
}

extension PlaceDetail {
    static let sample1: [PlaceDetail] = [
        PlaceDetail(placeID: UUID().uuidString, name: "오하이오", reviews: 3, rating: 4, imageURL: nil, latitude: 33.4580, longitude: 126.9405),
        PlaceDetail(placeID: UUID().uuidString, name: "돌하르방", reviews: 3, rating: 4, imageURL: nil, latitude: 33.3625, longitude: 126.5331),
        PlaceDetail(placeID: UUID().uuidString, name: "한라산", reviews: 3, rating: 4, imageURL: nil, latitude: 33.5223, longitude:126.7745 ),
        PlaceDetail(placeID: UUID().uuidString, name: "오설록", reviews: 3, rating: 4, imageURL: nil, latitude: 33.2490, longitude:126.5587 ),
    ]
    
    static let sample2: [PlaceDetail] = [
        PlaceDetail(placeID: UUID().uuidString, name: "구름비", reviews: 3, rating: 4, imageURL: nil, latitude: 33.3945, longitude: 126.2395),
        PlaceDetail(placeID: UUID().uuidString, name: "카페", reviews: 3, rating: 4, imageURL: nil, latitude: 33.4248, longitude: 126.9275),
        PlaceDetail(placeID: UUID().uuidString, name: "전망좋은", reviews: 3, rating: 4, imageURL: nil, latitude:33.3245, longitude:126.8347 ),
        PlaceDetail(placeID: UUID().uuidString, name: "베이커리", reviews: 3, rating: 4, imageURL: nil, latitude: 33.5173, longitude: 126.6528),
    ]
    
    private static func anyURL() -> URL {
        URL(string: "http://any.com")!
    }
}

struct Days {
    let places: [PlaceDetail]
}

extension Days {
    static let sample: [Days] = [
        Days(places: PlaceDetail.sample1),
        Days(places: PlaceDetail.sample2),
    ]
}
