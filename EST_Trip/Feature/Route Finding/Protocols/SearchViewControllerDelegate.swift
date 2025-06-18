//
//  SearchViewControllerDelegate.swift
//  EST_Trip
//
//  Created by 권도현 on 6/16/25.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewController(_ controller: SearchViewController, place: GooglePlaceDTO, for section: Int)
    func searchViewController(_ controller: SearchViewController, place: PlaceDTO, for section: Int)
}
