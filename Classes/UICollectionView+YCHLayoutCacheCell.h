//
//  UICollectionView+YCHLayoutCacheCell.h
//  Pods
//
//  Created by Kyle on 27/8/17.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YCHLayoutCacheCellCalculateType) {
    YCHLayoutCacheCellCalculateTypeUnknow,
    YCHLayoutCacheCellCalculateTypeWith,
    YCHLayoutCacheCellCalculateTypeHeight,
    YCHLayoutCacheCellCalculateTypeSize,
};

@interface UICollectionView (YCHLayoutCacheCell)

@property (nonatomic, assign) BOOL ych_enforceFrameLayout;

@property (nonatomic, assign) BOOL ych_isTempLayoutCell;

- (CGSize)ych_sizeForCellWithIdentifier:(NSString *)identifier
                           forIndexPath:(NSIndexPath *)indexPath
                              fixedSize:(CGSize)fixedSize
                          configuration:(void (^)(id cell))configuration;

- (CGSize)ych_sizeForCellWithIdentifier:(NSString *)identifier
                             cacheByKey:(id<NSCopying>)key
                             fixedValue:(CGFloat)fixedValue
                          calculateType:(YCHLayoutCacheCellCalculateType)calculateType
                          configuration:(void (^)(id cell))configuration;

- (CGSize)ych_sizeForCellWithIdentifier:(NSString *)identifier
                           forIndexPath:(NSIndexPath *)indexPath
                             fixedValue:(CGFloat)fixedValue
                          calculateType:(YCHLayoutCacheCellCalculateType)calculateType
                          configuration:(void (^)(id cell))configuration;

@end


