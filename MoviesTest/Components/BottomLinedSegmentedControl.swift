//
//  BottomLinedSegmentedControl.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 13/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class BottomLinedSegmentedControl: UIView {
    
    typealias Index = Int
    
    // MARK: - Views -
    lazy var bottomIndicator: UIView = {
        let indicator = UIView()
        indicator.backgroundColor = UIColor.custom.black
        return indicator
    }()
    
    lazy var contentView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    fileprivate var bottomIndicatorLeadingConstraint: NSLayoutConstraint?
    private var bottomIndicatorWidthConstraint: NSLayoutConstraint?
    
    fileprivate var itemContainers: [ItemContainer] = []
    
    // MARK: - Attributes -
    private let disposeBag = DisposeBag()
    let itemSelected = PublishSubject<Index>()
    var items: [String] = [] {
        didSet {
            for itemContainer in contentView.arrangedSubviews {
                contentView.removeArrangedSubview(itemContainer)
                itemContainer.removeFromSuperview()
            }
            items
                .map(ItemContainer.init)
                .indexedForEach { (item, index) in
                    item.tag = index
                    item.addTarget(self, action: #selector(itemContainerSelected(_:)), for: .touchUpInside)
                    item.isItemSelected = index == 0
                    contentView.addArrangedSubview(item)
                    itemContainers.append(item)
                    if index == 0 {
                        self.bottomIndicatorWidthConstraint?.isActive = false
                        self.bottomIndicatorWidthConstraint = nil
                        self.bottomIndicatorWidthConstraint = self.bottomIndicator.widthAnchor.constraint(equalTo: item.widthAnchor)
                        self.bottomIndicatorWidthConstraint?.isActive = true
                    }
                }
        }
    }
    
    // MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        sv([ contentView, bottomIndicator ])
        [contentView, bottomIndicator].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        [
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            bottomIndicator.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomIndicator.heightAnchor.constraint(equalToConstant: 2.0),
        ].forEach { $0.isActive = true }
        
        bottomIndicatorLeadingConstraint = bottomIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        bottomIndicatorLeadingConstraint?.isActive = true
    }
    
    // MARK: - Utils -
    func setSelectedItem(_ index: Int) {
        self.itemContainers
            .indexedForEach { (item, _index) in
                item.isItemSelected = _index == index
            }
    }
    
    // MARK: - Actions -
    @objc private func itemContainerSelected(_ button: UIButton) {
        let index = button.tag
        itemSelected.onNext(index)
        for (containerIndex, container) in itemContainers.enumerated() {
            container.isItemSelected = containerIndex == index
        }
    }
    
}

extension BottomLinedSegmentedControl {
    final class ItemContainer: UIButton {
        // MARK: - Views -
        lazy var label: UILabel = {
            let label = UILabel()
            label.font = ItemContainer.unselectedFont
            label.textColor = UIColor.custom.black
            label.textAlignment = .center
            return label
        }()
        
        // MARK: - Attributes -
        private static let selectedFont = UIFont(customFont: .openSansBold, size: 15.0)
        private static let unselectedFont = UIFont(customFont: .openSansRegular, size: 15.0)
        
        var isItemSelected: Bool = false {
            didSet {
                label.font = isItemSelected
                    ? ItemContainer.selectedFont
                    : ItemContainer.unselectedFont
                
                label.textColor = isItemSelected
                    ? UIColor.custom.black
                    : UIColor.custom.darkGray
            }
        }
        
        // MARK: - Init -
        init(text: String) {
            super.init(frame: CGRect.zero)
            commonInit()
            label.text = text
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        private func commonInit() {
            label.addMatchingSize(inside: self)
        }
    }
}

extension Reactive where Base: BottomLinedSegmentedControl {
    var progress: Binder<CGFloat> {
        return Binder(self.base) { (segmentedControl: BottomLinedSegmentedControl, progressValue: CGFloat) in
            segmentedControl.bottomIndicatorLeadingConstraint?.constant = (segmentedControl.itemContainers.first?.frame.width ?? 0.0) * progressValue
            segmentedControl.layoutIfNeeded()
        }
    }
}
