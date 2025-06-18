//
//  SearchViewModel.swift
//  EST_Trip
//
//  Created by kangho lee on 6/18/25.
//

import UIKit
import GooglePlacesSwift

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
    
    var headerText: String {
        "Day\(section + 1) 추천 장소"
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
                await fetchPhoto()
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
                
                await fetchPhoto()
                onReload?()
            } catch {
                onError?(error)
            }
        }
    }
    
    private func fetchPhoto() async {
        await withTaskGroup(of: (Int, UIImage?).self) { group in
            for (index, place) in filteredPlaces.enumerated() {
                guard let photo = place.place.photos?.first else { continue }
                
                group.addTask {
                    do {
                        let image = try await self.remotePlaceService.fetch(by: photo)
                        return (index, image)
                    } catch {
                        return (index, nil)
                    }
                }
            }
            
            for await (index, image) in group {
                filteredPlaces[index].image = image
            }
        }
    }
}
