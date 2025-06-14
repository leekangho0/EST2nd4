//
//  DraggableHeaderViewDelegate.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/14/25.
//

import UIKit

protocol DraggableHeaderViewDelegate: AnyObject {
    func draggableHeaderView(_ headerView: UIView, gesture: UIPanGestureRecognizer)
}
