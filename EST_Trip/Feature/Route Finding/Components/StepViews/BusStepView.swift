//
//  BusStepView.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/12/25.
//

import UIKit

protocol BusStepViewDelegate {
    func didUpdateHeight(index: Int, height: CGFloat)
}

class BusStepView: UIView {

    lazy var imageView = UIImageView()
    lazy var roundedView = RoundedView()
    lazy var stopNameLabel = UILabel()
    lazy var busNumberCollectionView = UICollectionView()
    
    lazy var busCountView = UIView()
    lazy var busCountLabel = UILabel()
    lazy var toggleStopListButton = UIButton()
    
    lazy var stopNameStackView = UIStackView()
    lazy var stopImageStackView = UIStackView()
    
    lazy var collectionViewHeightConstraint = busNumberCollectionView.heightAnchor.constraint(equalToConstant: 30)
    lazy var stopNameStackViewHeightConstraint = stopNameStackView.heightAnchor.constraint(equalToConstant: 100)
    
    var delegate: BusStepViewDelegate?
    var index = -1

    private var route: RouteTestData.Route?
    private let verticalSpacing: CGFloat = 10
    
    init(route: RouteTestData.Route) {
        super.init(frame: .zero)
        
        self.route = route
        
        setupView()
        setupConstraints()
        configure()
        
        toggleStopListButton.addTarget(self, action: #selector(toggleStopList(_:)), for: .touchUpInside)
        
        toggleStopList(toggleStopListButton.self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func toggleStopList(_ sender: UIButton) {
        self.stopNameStackView.isHidden.toggle()
        self.stopImageStackView.isHidden.toggle()

        var height = self.viewHeight()
        var imageName = "chevron.up"
        
        if self.stopNameStackView.isHidden {
            height -= self.stopNameStackViewHeightConstraint.constant
            imageName = "chevron.down"
        }
        
        self.toggleStopListButton.setBackgroundImage(.init(systemName: imageName), for: .normal)
        
        self.delegate?.didUpdateHeight(index: self.index, height: height)
    }

    private func setupView() {
        imageView.image = .init(systemName: "bus.fill")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        
        roundedView.backgroundColor = .jejuOrange
        
        busNumberCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        busNumberCollectionView.dataSource = self
        busNumberCollectionView.register(BusNumberCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: BusNumberCollectionViewCell.self))
        
        let textColor: UIColor = .init(red: 126, green: 126, blue: 126)
        let font: UIFont = .systemFont(ofSize: 15)
        
        stopNameLabel.textColor = textColor
        stopNameLabel.font = font
        
        busCountLabel.textColor = textColor
        busCountLabel.font = font
        
        toggleStopListButton.setBackgroundImage(.init(systemName: "chevron.down"), for: .normal)
        toggleStopListButton.tintColor = .init(red: 126, green: 126, blue: 126)
        
        stopNameStackView.axis = .vertical
        stopNameStackView.alignment = .fill
        stopNameStackView.distribution = .fillEqually
        
        stopImageStackView.axis = .vertical
        stopImageStackView.alignment = .fill
        stopImageStackView.distribution = .fillEqually
        
        self.addSubview(imageView)
        self.addSubview(roundedView)
        self.addSubview(stopNameLabel)
        self.addSubview(busNumberCollectionView)
        
        self.addSubview(busCountView)
        self.busCountView.addSubview(busCountLabel)
        self.busCountView.addSubview(toggleStopListButton)
        
        self.addSubview(stopNameStackView)
        self.addSubview(stopImageStackView)
        
        setupConstraints()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let cellHeight: CGFloat = 20
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(50),
            heightDimension: .absolute(cellHeight)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(cellHeight)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(5)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        stopNameLabel.translatesAutoresizingMaskIntoConstraints = false
        busNumberCollectionView.translatesAutoresizingMaskIntoConstraints = false
        busCountView.translatesAutoresizingMaskIntoConstraints = false
        busCountLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleStopListButton.translatesAutoresizingMaskIntoConstraints = false
        stopNameStackView.translatesAutoresizingMaskIntoConstraints = false
        stopImageStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.08),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.65),
            
            roundedView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            roundedView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            roundedView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            roundedView.widthAnchor.constraint(equalToConstant: 2),
            
            stopNameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            stopNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stopNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            
            busNumberCollectionView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: verticalSpacing),
            busNumberCollectionView.leadingAnchor.constraint(equalTo: stopNameLabel.leadingAnchor),
            busNumberCollectionView.trailingAnchor.constraint(equalTo: stopNameLabel.trailingAnchor),
            collectionViewHeightConstraint,
            
            busCountView.topAnchor.constraint(equalTo: self.busNumberCollectionView.bottomAnchor, constant: verticalSpacing),
            busCountView.leadingAnchor.constraint(equalTo: stopNameLabel.leadingAnchor),
            busCountView.trailingAnchor.constraint(equalTo: stopNameLabel.trailingAnchor),
            
            busCountLabel.topAnchor.constraint(equalTo: busCountView.topAnchor),
            busCountLabel.leadingAnchor.constraint(equalTo: busCountView.leadingAnchor),
            busCountLabel.bottomAnchor.constraint(equalTo: busCountView.bottomAnchor),
            
            toggleStopListButton.leadingAnchor.constraint(equalTo: busCountLabel.trailingAnchor, constant: 8),
            toggleStopListButton.trailingAnchor.constraint(lessThanOrEqualTo: busCountView.trailingAnchor),
            toggleStopListButton.centerYAnchor.constraint(equalTo: busCountLabel.centerYAnchor),
            toggleStopListButton.heightAnchor.constraint(equalTo: busCountLabel.heightAnchor, multiplier: 0.8),
            
            stopNameStackView.topAnchor.constraint(equalTo: busCountView.bottomAnchor, constant: verticalSpacing),
            stopNameStackView.leadingAnchor.constraint(equalTo: stopNameLabel.leadingAnchor),
            stopNameStackView.trailingAnchor.constraint(equalTo: stopNameLabel.trailingAnchor),
            stopNameStackViewHeightConstraint,
            
            stopImageStackView.topAnchor.constraint(equalTo: stopNameStackView.topAnchor),
//            stopImageStackView.bottomAnchor.constraint(equalTo: stopNameStackView.bottomAnchor),
            stopImageStackView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            stopImageStackView.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.8),
            stopImageStackView.heightAnchor.constraint(equalTo: stopNameStackView.heightAnchor)
        ])
    }
    
    private func configure() {
        guard let route, let stop = route.stop else { return }
        stopNameLabel.text = stop.departureName
        busCountLabel.text = "\(stop.intermediateStops.count)개 정류장 이동"
        
        // 마지막 셀 아래 여유 공간을 만들기 위해 빈 문자열 추가
        var intermediateStops = stop.intermediateStops
        intermediateStops.append(" ")
        
        let labelHeight: CGFloat = 25
        
        intermediateStops.indices.forEach {
            let intermediateStopLabel = intermediateStopLabel(
                stopName: intermediateStops[$0],
                height: labelHeight
            )
            stopNameStackView.addArrangedSubview(intermediateStopLabel)
            
            let intermediateImageView = intermediateImageView()
            intermediateImageView.alpha = $0 == intermediateStops.count - 1 ? 0 : 1
            stopImageStackView.addArrangedSubview(intermediateImageView)
        }
        
        stopNameStackViewHeightConstraint.constant = labelHeight * CGFloat(intermediateStops.count)
        
        DispatchQueue.main.async {
            self.updateCollectionViewHeight()
            // 초기에는 접힌 상태이므로 해당 높이를 제외하고 전달
            self.delegate?.didUpdateHeight(index: self.index, height: self.viewHeight() - self.stopNameStackViewHeightConstraint.constant)
        }
    }
    
    private func intermediateStopLabel(stopName: String, height: CGFloat) -> UILabel {
        let label = UILabel()
        
        label.textColor = .init(red: 126, green: 126, blue: 126)
        label.font = .systemFont(ofSize: 15)
        label.text = stopName
        label.minimumScaleFactor = 0.8
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return label
    }
    
    private func intermediateImageView() -> UIView {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = .jejuOrange
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        return view
    }
    
    private func updateCollectionViewHeight() {
        self.busNumberCollectionView.reloadData()
        collectionViewHeightConstraint.constant = busNumberCollectionView.contentSize.height
    }
    
    func viewHeight() -> CGFloat {
        let height = stopNameLabel.frame.height +
        collectionViewHeightConstraint.constant +
        busCountView.frame.height +
        stopNameStackViewHeightConstraint.constant +
        (verticalSpacing * 3)
        
        return height
    }
}

// MARK: - UICollectionViewDataSource
extension BusStepView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return route?.stop?.busInfos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BusNumberCollectionViewCell.self), for: indexPath) as? BusNumberCollectionViewCell,
                let busInfo = route?.stop?.busInfos[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        cell.configure(busInfo: busInfo)
        
        return cell
    }
}
