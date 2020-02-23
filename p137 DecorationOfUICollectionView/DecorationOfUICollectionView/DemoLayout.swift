//
//  DemoLayout.swift
//  DecorationOfUICollectionView
//
//  Created by FrankLiu on 15/12/3.
//  Copyright © 2015年 刘大帅. All rights reserved.
//
//  https://github.com/yafoolaw
//  https://www.jianshu.com/p/164e6e429020
//p137 decoration view

import UIKit

class DemoLayout: UICollectionViewFlowLayout {

    var cellCount    : Int?
    var sectionCount : Int?
    
    override func prepare() {
        
        super.prepare()
        
        self.cellCount               = self.collectionView?.numberOfItems(inSection: 0)
        self.sectionCount            = self.collectionView?.numberOfSections
        self.itemSize                = CGSize(width: 100, height: 100)
        self.sectionInset            = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        self.minimumInteritemSpacing = 40
        self.minimumLineSpacing      = 20
        
        self.register(DecorationView.classForCoder(), forDecorationViewOfKind: decorationIdentifier)
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath as IndexPath)
        
        attributes.frame  = CGRect(x: 0, y: indexPath.row * 120 + 12, width: Int(screenWidth), height: 120)
        //cell是0，背景就是-1 zIndex用于设置front-to-back层级；值越大，优先布局在上层；cell的zIndex为0
        attributes.zIndex = -1
        
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // 方法1: 通过主动调用 self.layoutAttributesForItemAtIndexPath(indexPath) 和 self.layoutAttributesForDecorationViewOfKind(decorationIdentifier, atIndexPath: indexPath) 生成全部 UICollectionViewLayoutAttributes
        var attributesArray = [UICollectionViewLayoutAttributes]()
        
        for i : Int in 0..<cellCount! {
        
            let indexPath = NSIndexPath(item: i, section: 0)
            let attributes = self.layoutAttributesForItem(at: indexPath as IndexPath)
            attributesArray.append(attributes!)
        }
        
        for i : Int in 0..<cellCount!/2 {
        
            let indexPath = NSIndexPath(row: i, section: 0)
            let attributes = self.layoutAttributesForDecorationView(ofKind: decorationIdentifier, at: indexPath as IndexPath)
            attributesArray.append(attributes!)
        }
        
        return attributesArray
        
        // 方法2: 通过调用 super.layoutAttributesForElementsInRect(rect) ,获得已经拥有的 UICollectionViewLayoutAttributes,根据已经拥有的,增添你需要的UICollectionViewLayoutAttributes
//        let attributes : [UICollectionViewLayoutAttributes]? = super.layoutAttributesForElementsInRect(rect)
//        
//        var allAttibutes = attributes
//        
//        for attribute in attributes! {
//            
//            if attribute.frame.origin.x == 25 {
//                
//                print(attribute.indexPath)
//                let decorationAttributes : UICollectionViewLayoutAttributes =
//                UICollectionViewLayoutAttributes(forDecorationViewOfKind: decorationIdentifier, withIndexPath: attribute.indexPath)
//                
//                decorationAttributes.frame =
//                    CGRect(x: 0, y: attribute.frame.origin.y - 10, width: screenWidth, height: 120)
//                
//                decorationAttributes.zIndex = attribute.zIndex - 1
//                
//                allAttibutes?.append(decorationAttributes)
//            }
//        }
//
//        return allAttibutes
    }
}
