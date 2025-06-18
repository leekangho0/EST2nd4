//
//  PlanSheetViewController.swift
//  EST_Trip
//
//  Created by kangho lee on 6/13/25.
//

import UIKit

protocol PlanSheetDelegate: AnyObject {
    func sheet(_ view: PlanSheetViewController, didSelectDayAt item: ScheduleEntity)
    func sheet(_ view: PlanSheetViewController, didSelectPlaceAt item: PlaceEntity)
}

final class PlanSheetViewController: UIViewController {
    @IBOutlet weak var dayCollectionView: UICollectionView!
    @IBOutlet weak var placeCollectionView: UICollectionView!
    
    weak var delegate: PlanSheetDelegate?
    
    private var shouldFirstSelection = true
    
    var days: [ScheduleEntity] = [] {
        didSet {
            DispatchQueue.main.async {
                self.dayCollectionView.reloadData()
            }
        }
    }
    
    private var currentDayIndex: Int = 0 {
        didSet {
            DispatchQueue.main.async { [self] in
                placeCollectionView.reloadData()
                placeCollectionView.setContentOffset(.zero, animated: true)
                if !currentPlaces.isEmpty {
                    currentPlace = currentPlaces[0]
                }
            }
        }
    }
    
    private var currentPlaces: [PlaceEntity] {
        !days.isEmpty
        ? days[currentDayIndex].orderedPlaces
        : []
    }
    
    // 똑같은 Place일 경우, event 보내지 않음
    private var currentPlace: PlaceEntity? {
        didSet {
            if let currentPlace, currentPlace != oldValue {
                self.delegate?.sheet(self, didSelectPlaceAt: currentPlace)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pane Style
        self.view.layer.cornerRadius = 16
        self.view.clipsToBounds = true
        
        register()
    }
    
    private func register() {
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        dayCollectionView.isMultipleTouchEnabled = false
        dayCollectionView.allowsSelection = true
        dayCollectionView.isScrollEnabled = true
        
        placeCollectionView.delegate = self
        placeCollectionView.dataSource = self
        placeCollectionView.isPagingEnabled = true
        
        setLayout()
    }
    
    private func setLayout() {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        // Paging 시 spacing이 있으면 scroll이 밀림
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let width = view.bounds.width
        layout.itemSize = .init(width: width, height: 150)
        
        placeCollectionView.collectionViewLayout = layout
        
    }
}

extension PlanSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dayCollectionView {
            currentDayIndex = indexPath.item
            delegate?.sheet(self, didSelectDayAt: days[currentDayIndex])
        } else {
            delegate?.sheet(self, didSelectPlaceAt: currentPlaces[indexPath.item])
        }
    }
    
    // User Event
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int((scrollView.contentOffset.x + scrollView.frame.width / 2) / scrollView.frame.width)
        // index 를 기반으로 현재 보여지는 셀을 처리
        print("현재 인덱스: \(index)")
        self.currentPlace = currentPlaces.isEmpty ? nil : currentPlaces[index]
    }
    
    // from method
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int((scrollView.contentOffset.x + scrollView.frame.width / 2) / scrollView.frame.width)
        // index 를 기반으로 현재 보여지는 셀을 처리
        print("현재 인덱스: \(index)")
        self.currentPlace = currentPlaces.isEmpty ? nil : currentPlaces[index]
    }
}

extension PlanSheetViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dayCollectionView {
            return days.count
        } else if collectionView == placeCollectionView {
            return currentPlaces.count
        } else {
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dayCollectionView {
            let cell = collectionView.dequeueReusableCell(type: DayCollectionViewCell.self, for: indexPath)
            cell.titleLabel.text = "Day \(indexPath.item + 1)"
            
            if indexPath.item == 0 {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
                self.collectionView(collectionView, didSelectItemAt: indexPath)
            }
            return cell
        } else if collectionView == placeCollectionView {
            let cell = collectionView.dequeueReusableCell(type: PlaceDetailCollectionViewCell.self, for: indexPath)
            let item = currentPlaces[indexPath.item]
            cell.nameLabel.text = item.name
            cell.ratingLabel.text = "카테고리 \(item.categoryType.name)"
            cell.contentLabel.text = item.description
            cell.reviewCountLabel.text = item.ratingText
            if let data = item.photo {
                cell.imageView.image = UIImage(data: data)
            } else {
                cell.imageView.image = UIImage(resource: .image)
            }
            
            return cell
        } else {
            fatalError()
        }
    }
}
