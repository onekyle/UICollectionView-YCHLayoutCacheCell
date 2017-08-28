//
//  UICollectionView+YCHKeyedCache.h
//  Pods
//
//  Created by Kyle on 27/8/17.
//
//

#import <UIKit/UIKit.h>

@interface YCHKeyedCache : NSObject

- (BOOL)existsSizeForKey:(id<NSCopying>)key;

- (void)cacheSize:(CGSize)size forKey:(id<NSCopying>)key;

- (CGSize)sizeForKey:(id<NSCopying>)key;

- (void)invalidateSizeForKey:(id<NSCopying>)key;

- (void)invalidateAllSizeCache;

@end

@interface UICollectionView (YCHKeyedCache)

@property (nonatomic, strong, readonly) YCHKeyedCache *ych_keyedSizeCache;

@end
