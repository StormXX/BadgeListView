//
//  BadgeListView.swift
//  BadgeListView
//
//  Created by DangGu on 15/12/22.
//  Copyright © 2015年 StormXX. All rights reserved.
//

import UIKit

open class BadgeListView: UIView {
    
    fileprivate var rowContainerViews: [UIView] = []
    fileprivate var badgeViews: [BadgeView] = []
    fileprivate var currentRow: Int = 0
    fileprivate var currentRowWidth: CGFloat = 0
    
    open var badgeSpacing: CGFloat = 5.0
    open var rowSpacing: CGFloat = 5.0
    open var edgeInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    open func addBadge(_ badge: BadgeView) {
        badgeViews.append(badge)
        let maxWidth = self.width - (edgeInset.left + edgeInset.right)
        if badge.width > maxWidth {
            badge.frame.size.width = maxWidth
        }
        
        var currentRowContainerView: UIView!
        if currentRow == 0 || currentRowWidth + badge.width + badgeSpacing > frame.width {
            currentRow += 1
            currentRowWidth = badge.width
            currentRowContainerView = UIView()
            let originYOfCurrentRowContainerView = rowContainerViews.compactMap({ view in view.height}).reduce(0, {$0 + $1}) + rowSpacing * CGFloat(currentRow - 1)
            badge.frame.origin = CGPoint(x: 0, y: 0)
            currentRowContainerView.frame = CGRect(x: edgeInset.left, y: originYOfCurrentRowContainerView + edgeInset.top, width: currentRowWidth - (edgeInset.left + edgeInset.right), height: badge.height)
            currentRowContainerView.addSubview(badge)
            rowContainerViews.append(currentRowContainerView)
            addSubview(currentRowContainerView)
        } else {
            badge.frame.origin = CGPoint(x: currentRowWidth + badgeSpacing, y: 0)
            currentRowWidth += badge.width + badgeSpacing
            currentRowContainerView = rowContainerViews[currentRow - 1]
            currentRowContainerView.frame.size.width = currentRowWidth
            currentRowContainerView.frame.size.height = max(currentRowContainerView.height, badge.height)
            currentRowContainerView.addSubview(badge)
        }
        self.frame.size = intrinsicContentSize
    }
    
    open func removeAllBadges() {
        badgeViews.forEach { (badgeView) -> () in
            badgeView.removeFromSuperview()
        }
        rowContainerViews.forEach { (containerView) -> () in
            containerView.removeFromSuperview()
        }
        badgeViews.removeAll()
        rowContainerViews.removeAll()
        currentRow = 0
        currentRowWidth = 0.0
        self.frame.size = intrinsicContentSize
    }
    
    open override var intrinsicContentSize : CGSize {
        let height: CGFloat = rowContainerViews.compactMap({ view in view.height}).reduce(0, {$0 + $1}) + CGFloat(rowContainerViews.count - 1) * rowSpacing
        return CGSize(width: self.width, height: height + (edgeInset.top + edgeInset.bottom))
    }
}
