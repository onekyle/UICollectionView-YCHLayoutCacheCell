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

- (BOOL)existsSizeAtIndexPath:(NSIndexPath *)indexPath;

- (void)cacheSize:(CGSize)size forIndexPath:(NSIndexPath *)indexPath;

- (CGSize)sizeForIndexPath:(NSIndexPath *)indexPath;

- (void)invalidateSizeAtIndexPath:(NSIndexPath *)indexPath;

- (void)invalidateAllSizeCache;

@end

@interface UICollectionView (YCHIndexPathCache)

@property (nonatomic, strong, readonly) YCHIndexPathCache *ych_indexPathCache;

@property (nonatomic, strong, readonly) NSMutableDictionary *tempCells;

@end

@interface UICollectionView (YCHIndexPathCacheInvalidation)

- (void)ych_reloadDataWithoutInvalidateIndexPathSizeCache;

@end
