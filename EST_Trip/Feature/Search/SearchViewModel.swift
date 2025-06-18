//
//  SearchViewModel.swift
//  EST_Trip
//
//  Created by kangho lee on 6/18/25.
//

import UIKit
import GooglePlacesSwift

struct GooglePlaceDTO {
    let place: Place
    let image: UIImage?
}

extension GooglePlaceDTO {
    func apply(_ entity: PlaceEntity) {
        entity.latitude = place.location.latitude
        entity.longitude = place.location.longitude
        entity.name = place.displayName
        entity.photo = image?.jpegData(compressionQuality: 1)
        entity.categoryType = CategoryType.from(placeTypes: place.types.map(\.rawValue))
        entity.address = place.formattedAddress
        entity.id = UUID(uuidString: place.placeID ?? UUID().uuidString) ?? UUID()
    }
}

class SearchViewModel {
    var selectedCategory: CategoryType?
    private let remotePlaceService: RemotePlaceService
    let section: Int
    
    var filteredPlaces: [GooglePlaceDTO] = []
    
    var onError: ((Error) -> Void)?
    var onReload: (() -> Void)?
    var onPlace: ((GooglePlaceDTO) -> Void)?
    
    var numberOfRowsInSection: Int {
        filteredPlaces.count
    }
    
    init(service: RemotePlaceService, section: Int) {
        self.remotePlaceService = service
        self.section = section
    }
    
    func item(for indexPath: IndexPath) -> GooglePlaceDTO {
        filteredPlaces[indexPath.item]
    }
    
    func selectCategory(_ category: CategoryType) {
        selectedCategory = category
    }
    
    // 카테고리를 선택하면 검색
    func loadByCategory() {
        let category = selectedCategory ?? .travel
        Task {
            do {
                let places = try await remotePlaceService.fetch(by: category.name, category: selectedCategory)
                filteredPlaces = places.map { GooglePlaceDTO(place: $0, image: nil) }
                onReload?()
            } catch {
                onError?(error)
            }
        }
    }
    
    // id를 이용하여 검색
    func load(by id: String) {
        Task {
            do {
                let place = try await remotePlaceService.fetchPlace(by: id)
                if let photo = place.photos?.first {
                    let image = try await remotePlaceService.fetch(by: photo)
                    onPlace?(GooglePlaceDTO(place: place, image: image))
                }
            } catch {
                onError?(error)
            }
        }
    }
    
    func loadFromText(text: String) {
        Task {
            do {
               let places = try await remotePlaceService.fetch(by: text, category: nil)
                filteredPlaces = places.map { GooglePlaceDTO(place: $0, image: nil) }
                onReload?()
            } catch {
                onError?(error)
            }
        }
    }
}
