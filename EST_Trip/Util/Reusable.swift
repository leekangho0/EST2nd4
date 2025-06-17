//
//  Reusable.swift
//  EST_Trip
//
//  Created by kangho lee on 6/12/25.
//

import UIKit

protocol Reusable {
    static var reusableID: String { get }
}

extension Reusable {
    static var reusableID: String {
        String(describing: Self.self)
    }
}

extension UIStoryboard: Reusable { }

extension UIViewController: Reusable { }

extension UICollectionViewCell: Reusable { }

extension UICollectionView {
    func dequeueReusableCell<T: Reusable>(type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: T.reusableID, for: indexPath) as! T
    }
}
