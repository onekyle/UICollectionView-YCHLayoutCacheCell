//
//  UICollectionView+YCHKeyedCache.m
//  Pods
//
//  Created by Kyle on 27/8/17.
//
//

#import "UICollectionView+YCHKeyedCache.h"
#import <objc/runtime.h>
#import "YCHLayoutCacheCellMacros.h"

@interface YCHKeyedCache ()

@property (nonatomic, strong) NSMutableDictionary<id<NSCopying>, NSValue *> *sizesByKey;

@end

@implementation YCHKeyedCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sizesByKey = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)existsSizeForKey:(id<NSCopying>)key
{
    NSValue *number = self.sizesByKey[key];
    return number && ![number isEqualToValue:YCHLayoutCellInvalidateSizeValue];
}

- (void)cacheSize:(CGSize)size byKey:(id<NSCopying>)key
{
    self.sizesByKey[key] = YHCLayoutSizeValueMake(size);
}

- (CGSize)sizeForKey:(id<NSCopying>)key
{
    return self.sizesByKey[key].CGSizeValue;
}

- (void)invalidateSizeForKey:(id<NSCopying>)key
{
    [self.sizesByKey removeObjectForKey:key];
}

- (void)invalidateAllSizeCache
{
    [self.sizesByKey removeAllObjects];
}

@end

@implementation UICollectionView (YCHKeyedCache)

- (YCHKeyedCache *)ych_keyedSizeCache
{
    YCHKeyedCache *cache = objc_getAssociatedObject(self, _cmd);
    if (!cache) {
        cache = [YCHKeyedCache new];
        objc_setAssociatedObject(self, _cmd, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

@end
