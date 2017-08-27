//
//  UICollectionView+YCHIndexPathCache.m
//  Pods
//
//  Created by Kyle on 27/8/17.
//
//

#import "UICollectionView+YCHIndexPathCache.h"
#import <objc/runtime.h>

typedef NSMutableArray <NSMutableArray<NSNumber *> *> YCHIndexPathLengthsBySection;

@interface YCHIndexPathCache ()

@property (nonatomic, strong) YCHIndexPathLengthsBySection *lengthsBySection;

@end

@implementation YCHIndexPathCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lengthsBySection = [NSMutableArray array];
    }
    return self;
}

- (BOOL)existsLengthAtIndexPath:(NSIndexPath *)indexPath
{
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSNumber *number = self.lengthsBySection[indexPath.section][indexPath.item];
    return ![number isEqualToNumber:@-1];
}

- (void)cacheLength:(CGFloat)length byIndexPath:(NSIndexPath *)indexPath
{
    self.automaticallyEnableed = YES;
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    self.lengthsBySection[indexPath.section][indexPath.item] = @(length);
}

- (CGFloat)lengthForIndexPath:(NSIndexPath *)indexPath
{
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSNumber *number = self.lengthsBySection[indexPath.section][indexPath.item];
#if CGFLOAT_IS_DOUBLE
    return number.doubleValue;
#else
    return number.floatValue;
#endif
}

- (void)invalidateLengthAtIndexPath:(NSIndexPath *)indexPath
{
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    self.lengthsBySection[indexPath.section][indexPath.item] = @-1;
}

- (void)invalidateAllLengthCache {
    [self.lengthsBySection removeAllObjects];
}


- (void)buildCachesAtIndexPathsIfNeeded:(NSArray *)indexPaths
{
    // Build every section array or item array which is smaller than given index path.
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [self buildSectionsIfNeeded:indexPath.section];
        [self buildItemsIfNeeded:indexPath.item inExistSection:indexPath.section];
    }];
}

- (void)buildSectionsIfNeeded:(NSInteger)targetSection
{
    for (NSInteger section = 0; section <= targetSection; ++section) {
        if (section >= _lengthsBySection.count) {
            _lengthsBySection[section] = [NSMutableArray array];
        }
    }
}

- (void)buildItemsIfNeeded:(NSInteger)targetItem inExistSection:(NSInteger)section
{
    NSMutableArray<NSNumber *> *lengthsByItem = _lengthsBySection[section];
    for (NSInteger item = 0; item <= targetItem; ++item) {
        if (item >= lengthsByItem.count) {
            lengthsByItem[item] = @-1;
        }
    }
}


@end

@implementation UICollectionView (YCHIndexPathCache)

- (YCHIndexPathCache *)ych_indexPathCache
{
    YCHIndexPathCache *cache = objc_getAssociatedObject(self, _cmd);
    if (!cache) {
        cache = [YCHIndexPathCache new];
        objc_setAssociatedObject(self, _cmd, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

@end
