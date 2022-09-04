//
//  TheatreViewController.swift
//  App Designs
//
//  Created by varunbhalla19 on 04/09/22.
//

import UIKit

class TheatreViewController: UIViewController {

    let totalSeats = 30 + 30
    
    lazy var seatsCollectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: getSeatsLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.isScrollEnabled = false
        collectionView.alwaysBounceVertical = false
        
        collectionView.register(TheatreSeatCell.self, forCellWithReuseIdentifier: TheatreSeatCell.identifier)
        collectionView.register(TheatreLegendCell.self, forCellWithReuseIdentifier: TheatreLegendCell.identifier)
        collectionView.register(TheatreDateCell.self, forCellWithReuseIdentifier: TheatreDateCell.identifier)
        collectionView.register(TheatreTimeCell.self, forCellWithReuseIdentifier: TheatreTimeCell.identifier)
        
        return collectionView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray5
        
        view.addSubview(seatsCollectionView)
        seatsCollectionView.backgroundColor = .magenta.withAlphaComponent(0.2)
        seatsCollectionView.fit(in: view, padding: .init(top: 100, left: 8, bottom: 100, right: 8))
     
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            let allCells = self.seatsCollectionView.visibleCells
            let legends = allCells.compactMap { $0 as? TheatreLegendCell }
            print("allCells: \(allCells.count) | \(legends.count)")
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("collSize: \(seatsCollectionView.bounds)")
    }
    
    let dates = ["11", "12", "13", "14", "15"]
    let times = ["10:00 AM", "01:00 PM", "04:00 PM", "07:00 PM", "11:00 PM"]
    
}

extension TheatreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return totalSeats
        case 1:
            return 3
        case 2:
            return dates.count
        default:
            return times.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TheatreSeatCell.identifier, for: indexPath) as? TheatreSeatCell else { fatalError("TheatreSeatCell not found!") }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TheatreLegendCell.identifier, for: indexPath) as? TheatreLegendCell else { fatalError("TheatreLegendCell not found!") }
            cell.textLabel.text = "Reserved"
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TheatreDateCell.identifier, for: indexPath) as? TheatreDateCell else { fatalError("TheatreDateCell not found!") }
            cell.textLabel.text = dates[indexPath.row]
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TheatreTimeCell.identifier, for: indexPath) as? TheatreTimeCell else { fatalError("TheatreTimeCell not found!") }
            cell.textLabel.text = times[indexPath.row]
            return cell
        }
    }
}

extension TheatreViewController {
    
    func getLegendsSection() -> NSCollectionLayoutSection {
        let sectionHeight = CGFloat.init(48)

        let size = NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(sectionHeight))
        let item = NSCollectionLayoutItem.init(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(sectionHeight)),
            subitem: item,
            count: 3
        )
        group.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        return NSCollectionLayoutSection.init(group: group)
    }
    
    func getSeatsSection(with contentSize: CGSize) -> NSCollectionLayoutSection {
        let containerSize = contentSize.width

        let numberOfLines = 8
            
        let seatInsets = CGFloat.init(2)
        let seatDimension = CGFloat.init(40)
        let rowHeight = seatDimension
        let estimatedRowHeight = NSCollectionLayoutDimension.estimated(rowHeight)

        let midRowSeatSize = seatDimension * 8
        let midRowSpace = containerSize - midRowSeatSize

        let edgeRowSeatSize = seatDimension * 6
        let edgeRowSpace = containerSize - edgeRowSeatSize
        let edgeInsets = edgeRowSpace - midRowSpace/2
        
        let verticalPadding = 64.0// containerHeight - (rowHeight * CGFloat.init(numberOfLines))
        
        let item = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .absolute(seatDimension), heightDimension: .absolute(seatDimension)))
        item.contentInsets = .init(top: seatInsets, leading: seatInsets, bottom: seatInsets, trailing: seatInsets)

        let topOrBottomgroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: estimatedRowHeight),
            subitem: item,
            count: 3
        )
        topOrBottomgroup.contentInsets = .init(top: 0, leading: edgeInsets/2, bottom: 0, trailing: midRowSpace/4)

        let topOrBottomgroup2 = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: estimatedRowHeight),
            subitem: item,
            count: 3
        )
        topOrBottomgroup2.contentInsets = .init(top: 0, leading: midRowSpace/4, bottom: 0, trailing: edgeInsets/2)
        
        
        let topOrBottomrow = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: estimatedRowHeight),
            subitems: [topOrBottomgroup, topOrBottomgroup2]
        )
                    
        let midgroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: estimatedRowHeight),
            subitem: item,
            count: 4
        )
        midgroup.contentInsets = .init(top: 0, leading: midRowSpace/4, bottom: 0, trailing: midRowSpace/4)
        
        
        let midRow = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: estimatedRowHeight),
            subitem: midgroup,
            count: 2
        )
        
        let finalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute((rowHeight * CGFloat.init(numberOfLines)) + (verticalPadding * (3/4) ) ) //.fractionalHeight(1)
            ),
            subitems: [topOrBottomrow, midRow, midRow, midRow, midRow, midRow, midRow, topOrBottomrow]
        )
        
        finalGroup.contentInsets = .init(
            top: verticalPadding/2,
            leading: 0,
            bottom: verticalPadding/4,
            trailing: 0
        )

        return NSCollectionLayoutSection.init(group: finalGroup)

    }
    
    func getDatesSection() -> NSCollectionLayoutSection {
        let itemSize = CGSize.init(width: 64, height: 48)

        let size = NSCollectionLayoutSize.init(widthDimension: .absolute(itemSize.width), heightDimension: .absolute(itemSize.height))
        
        let item = NSCollectionLayoutItem.init(layoutSize: size)
        
        let finalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            subitem: item,
            count: 1
        )

        let section = NSCollectionLayoutSection.init(group: finalGroup)
        section.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        return section
    }
    
    func getTimeSection() -> NSCollectionLayoutSection {
        let itemSize = CGSize.init(width: 96, height: 48)

        let size = NSCollectionLayoutSize.init(widthDimension: .absolute(itemSize.width), heightDimension: .absolute(itemSize.height))
        
        let item = NSCollectionLayoutItem.init(layoutSize: size)
        
        let finalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            subitem: item,
            count: 1
        )

        let section = NSCollectionLayoutSection.init(group: finalGroup)
//        section.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        return section
    }
    
    func getSeatsLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout.init { sectionIndex, environment in
            print("size: \(environment.container.contentSize)")
            if sectionIndex == 0 {
                return self.getSeatsSection(with: environment.container.contentSize)
            }
            if sectionIndex == 1 {
                return self.getLegendsSection()
            }
            if sectionIndex == 2 {
                return self.getDatesSection()
            }
            return self.getTimeSection()
        }
    }
    
}

class TheatreSeatCell: UICollectionViewCell {
    
    static let identifier = "TheatreSeatCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("cell size: \(frame.size)")
        setBorder()
        layer.cornerRadius = 6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TheatreLegendCell: UICollectionViewCell {
    
    static let identifier = "TheatreLegendCell"
    
    lazy var textLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var dotView: UIView = {
        let dot = UIView.init(frame: .init(origin: .zero, size: .init(width: 16, height: 16)))
        dot.backgroundColor = .magenta
        dot.layer.cornerRadius = 6
        return dot
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBorder()
        
        contentView.addSubview(textLabel)
        contentView.addSubview(dotView)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        dotView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dotView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dotView.heightAnchor.constraint(equalToConstant: 12),
            dotView.widthAnchor.constraint(equalToConstant: 12),
            textLabel.leadingAnchor.constraint(equalTo: dotView.trailingAnchor, constant: 8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TheatreDateCell: UICollectionViewCell {
    
    static let identifier = "TheatreDateCell"
    
    lazy var textLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBorder()
        
        contentView.addSubview(textLabel)
        textLabel.center(in: contentView)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TheatreTimeCell: UICollectionViewCell {
    
    static let identifier = "TheatreTimeCell"
    
    lazy var textLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBorder()
        
        contentView.addSubview(textLabel)
        textLabel.center(in: contentView)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension UIView {
    
    func fit(in view: UIView, padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding.right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding.bottom)
        ])
    }
    
    func center(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setBorder(with color: UIColor = .white, width: CGFloat = 1) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
}
