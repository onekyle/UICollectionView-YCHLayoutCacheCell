//
//  UICollectionView+YCHIndexPathCache.h
//  Pods
//
//  Created by Kyle on 27/8/17.
//
//

#import <UIKit/UIKit.h>

@interface YCHIndexPathCache : NSObject

@property (nonatomic, assign, getter=isAutomaticallyEnableed) BOOL automaticallyEnableed;

- (BOOL)existsLengthAtIndexPath:(NSIndexPath *)indexPath;

- (void)cacheLength:(CGFloat)length byIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)lengthForIndexPath:(NSIndexPath *)indexPath;

- (void)invalidateLengthAtIndexPath:(NSIndexPath *)indexPath;

- (void)invalidateAllLengthCache;

@end

@interface UICollectionView (YCHIndexPathCache)

@property (nonatomic, strong, readonly) YCHIndexPathCache *ych_indexPathCache;

@end

