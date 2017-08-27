//
//  UICollectionView+YCHLayoutCacheCell.h
//  Pods
//
//  Created by Kyle on 27/8/17.
//
//

#import <UIKit/UIKit.h>

@interface UICollectionView (YCHLayoutCacheCell)

- (__kindof UICollectionViewCell *)ych_templateCellForReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

- (CGSize)ych_sizeForCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id cell))configuration;

- (CGSize)ych_sizeForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id cell))configuration;

- (CGSize)ych_sizeForCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath cacheByKey:(id<NSCopying>)key configuration:(void (^)(id cell))configuration;

@end


