//
//  UICollectionView+YCHKeyedCache.m
//  Pods
//
//  Created by Kyle on 27/8/17.
//
//

#import "UICollectionView+YCHKeyedCache.h"
#import <objc/runtime.h>

@interface YCHKeyedCache ()

@property (nonatomic, strong) NSMutableDictionary<id<NSCopying>, NSNumber *> *LengthsByKey;

@end

@implementation YCHKeyedCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        _LengthsByKey = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)existsLengthForKey:(id<NSCopying>)key
{
    NSNumber *number = self.LengthsByKey[key];
    return number && number.intValue != -1;
}

- (void)cacheLength:(CGFloat)length byKey:(id<NSCopying>)key
{
    self.LengthsByKey[key] = @(length);
}

- (CGFloat)LengthForKey:(id<NSCopying>)key
{
#if CGFLOAT_IS_DOUBLE
    return [self.LengthsByKey[key] doubleValue];
#else
    return [self.LengthsByKey[key] floatValue];
#endif
}

- (void)invalidateLengthForKey:(id<NSCopying>)key
{
    [self.LengthsByKey removeObjectForKey:key];
}

- (void)invalidateAllLengthCache
{
    [self.LengthsByKey removeAllObjects];
}

@end

@implementation UICollectionView (YCHKeyedCache)

- (YCHKeyedCache *)ych_keyedLengthCache
{
    YCHKeyedCache *cache = objc_getAssociatedObject(self, _cmd);
    if (!cache) {
        cache = [YCHKeyedCache new];
        objc_setAssociatedObject(self, _cmd, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

@end
