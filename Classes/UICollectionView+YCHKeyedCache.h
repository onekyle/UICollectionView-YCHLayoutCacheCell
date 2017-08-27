//
//  UICollectionView+YCHKeyedCache.h
//  Pods
//
//  Created by Kyle on 27/8/17.
//
//

#import <UIKit/UIKit.h>

@interface YCHKeyedCache : NSObject

- (BOOL)existsLengthForKey:(id<NSCopying>)key;

- (void)cacheLength:(CGFloat)length byKey:(id<NSCopying>)key;

- (CGFloat)LengthForKey:(id<NSCopying>)key;

- (void)invalidateLengthForKey:(id<NSCopying>)key;

- (void)invalidateAllLengthCache;

@end

@interface UICollectionView (YCHKeyedCache)

@property (nonatomic, strong, readonly) YCHKeyedCache *ych_keyedLengthCache;

@end
