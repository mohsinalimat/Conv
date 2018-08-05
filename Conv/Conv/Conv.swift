//
//  Conv.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public final class Conv: NSObject {
    public weak var collectionView: UICollectionView?
    
    public var sections: [Section] = []
    public weak var scrollViewDelegate: UIScrollViewDelegate?
    
    public override init() {
        super.init()
    }
    
    internal var didMoveItem: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)?
    internal var indexTitles: ((_ collectionView: UICollectionView) -> [String])?
    internal var indexTitle: ((_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath)?
    internal var transitionLayout: ((_ collectionView: UICollectionView, _ fromLayout: UICollectionViewLayout, _ toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout)?
    internal var shouldUpdateFocus: ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext) -> Bool)?
    internal var didUpdateFocus: ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void)?
    internal var indexPathForPreferredFocusedView: ((_ collectionView: UICollectionView) -> IndexPath?)?
    internal var targetContentOffset: ((_ collectionView: UICollectionView, _ proposedContentOffset: CGPoint) -> CGPoint)?
    
    public func reload() {
        guard let oldConv = collectionView?.oldConv else {
            return
        }
        
        if let newConv = collectionView?.newConv {
            let sectionOperations = diff(
                from: oldConv.sections.map { $0.diffElement! },
                to: newConv.sections.map { $0.diffElement! }
            )
            
            collectionView?
                .performBatchUpdates({
                collectionView?.deleteItems(at: <#T##[IndexPath]#>)
            }, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        }
        collectionView?.shiftConv()
    }
}

extension Conv {
    public func didMoveItem(_ closure: @escaping ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)) {
        self.didMoveItem = closure
    }
    public func indexTitles(_ closure: @escaping ((_ collectionView: UICollectionView) -> [String])) {
        self.indexTitles = closure
    }
    public func indexTitle(_ closure: @escaping ((_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath)) {
        self.indexTitle = closure
    }
    public func transitionLayout(_ closure: @escaping ((_ collectionView: UICollectionView, _ fromLayout: UICollectionViewLayout, _ toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout)) {
        self.transitionLayout = closure
    }
    public func shouldUpdateFocus(_ closure: @escaping ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext) -> Bool)) {
        self.shouldUpdateFocus = closure
    }
    public func didUpdateFocus(_ closure: @escaping ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void)) {
        self.didUpdateFocus = closure
    }
    public func indexPathForPreferredFocusedView(_ closure: @escaping ((_ collectionView: UICollectionView) -> IndexPath?)) {
        self.indexPathForPreferredFocusedView = closure
    }
    public func targetContentOffset(_ closure: @escaping ((_ collectionView: UICollectionView, _ proposedContentOffset: CGPoint) -> CGPoint)) {
        self.targetContentOffset = closure
    }
}

extension Conv {
    @discardableResult public func create<E: Differenciable>(for elements: [E], sections closure: (E, Section) -> Void) -> Self {
        let sections = elements.map { (element) in
            Section(diffElement: element) { section in
                closure(element, section)
            }
        }
        
        self.sections.append(contentsOf: sections)
        return self
    }
}

