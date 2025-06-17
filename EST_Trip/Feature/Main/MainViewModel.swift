//
//  MainViewModel.swift
//  EST_Trip
//
//  Created by kangho lee on 6/17/25.
//

import Foundation
import CoreData

protocol MainViewModelDelegate {
    func reload()
}

class MainViewModel {
    enum TravelSection: Int {
        case prior
        case upcoming
    }
    
    private var travel: [TravelEntity] = []

    private var futureTrip: [TravelEntity] = []
    private var pastTrip: [TravelEntity] = []
    
    private let travelProvider: TravelProvider
    
    var reloadClosure: (() -> Void)?
    
    init(travelProvider: TravelProvider) {
        self.travelProvider = travelProvider
    }
    
    var numberOfRowsInSection: Int {
        travel.count
    }
    
    func item(for IndexPath: IndexPath) -> TravelEntity {
        travel[IndexPath.item]
    }
    
    func bind(reloadAction: @escaping () -> Void) {
        travelProvider.delegate = self
        reloadClosure = reloadAction
    }
    
    // fetch된 entity를 가져옴
    func notifyAll() {
        travelProvider.notifyAll()
    }
    
    func setSection(_ section: TravelSection) {
        switch section {
        case .prior:
            travel = pastTrip
        case .upcoming:
            travel = futureTrip
        }
        reloadClosure?()
    }
}

// TravelProvider에서 가져온 entity를 각각 section에 넣어준다.
extension MainViewModel: TravelProviderDelegate {
    func travelProviderDidUpdatePrior(_ travels: [TravelEntity]) {
        pastTrip = travels
        reloadClosure?()
    }
    
    func travelProviderDidUpdateUpcoming(_ travels: [TravelEntity]) {
        futureTrip = travels
        reloadClosure?()
    }
}
