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

@implementation UICollectionView (YCHIndexPathCacheInvalidation)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _ych_swizzlingMethods];
    });
}

+ (void)_ych_swizzlingMethods {
    SEL selectors[] = {
        @selector(registerNib:forCellWithReuseIdentifier:),
        @selector(registerClass:forCellWithReuseIdentifier:),
        @selector(reloadData),
        @selector(reloadSections:),
        @selector(insertSections:),
        @selector(moveSection:toSection:),
        @selector(deleteSections:),
        @selector(reloadItemsAtIndexPaths:),
        @selector(insertItemsAtIndexPaths:),
        @selector(deleteItemsAtIndexPaths:),
        @selector(moveItemAtIndexPath:toIndexPath:)
    };
    
    for (int i = 0; i < sizeof(selectors) / sizeof(SEL); i++) {
        SEL originalSelector = selectors[i];
        SEL swizzledSelector = NSSelectorFromString([@"ych_"
                                                     stringByAppendingString:NSStringFromSelector(originalSelector)]);
        
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)ych_reloadDataWithoutInvalidateIndexPathLengthCache
{
    [self ych_reloadData];
}

- (void)ych_registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier
{
    [self ych_registerNib:nib forCellWithReuseIdentifier:identifier];
    if (self.ych_indexPathCache.isAutomaticallyEnableed) {
        UICollectionViewCell *tempCell = [[nib instantiateWithOwner:nil options:nil] lastObject];
        self.templeCells[identifier] = tempCell;
    }
}

- (void)ych_registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [self ych_registerClass:cellClass forCellWithReuseIdentifier:identifier];
    if (self.ych_indexPathCache.isAutomaticallyEnableed) {
        UICollectionViewCell *tempCell = [[cellClass alloc] initWithFrame:CGRectZero];
        self.templeCells[identifier] = tempCell;
    }
}

- (void)ych_reloadData
{
    if (self.ych_indexPathCache.isAutomaticallyEnableed) {
        [self.ych_indexPathCache.lengthsBySection removeAllObjects];
    }
    [self ych_reloadData];
}

- (void)ych_reloadSections:(NSIndexSet *)sections
{
    if (self.ych_indexPathCache.isAutomaticallyEnableed) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL * _Nonnull stop) {
            [self.ych_indexPathCache buildSectionsIfNeeded:section];
            [self.ych_indexPathCache.lengthsBySection[section] removeAllObjects];
        }];
    }
    [self ych_reloadSections:sections];
}

- (void)ych_insertSections:(NSIndexSet *)sections
{
    if (self.ych_indexPathCache.isAutomaticallyEnableed) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL * _Nonnull stop) {
            [self.ych_indexPathCache buildSectionsIfNeeded:section];
            [self.ych_indexPathCache.lengthsBySection insertObject:[NSMutableArray array] atIndex:section];
        }];
    }
    [self ych_insertSections:sections];
}

- (void)ych_moveSection:(NSInteger)section toSection:(NSInteger)newSection
{
    if (self.ych_indexPathCache.isAutomaticallyEnableed) {
        [self.ych_indexPathCache buildSectionsIfNeeded:section];
        [self.ych_indexPathCache buildSectionsIfNeeded:newSection];
        [self.ych_indexPathCache.lengthsBySection exchangeObjectAtIndex:section withObjectAtIndex:newSection];
    }
    [self ych_moveSection:section toSection:newSection];
}

- (void)ych_deleteSections:(NSIndexSet *)sections
{
    if (self.ych_indexPathCache.isAutomaticallyEnableed) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL * _Nonnull stop) {
            [self.ych_indexPathCache buildSectionsIfNeeded:section];
            [self.ych_indexPathCache.lengthsBySection removeObjectAtIndex:section];
        }];
    }
    [self ych_deleteSections:sections];
}

- (void)ych_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    if (self.ych_indexPathCache.isAutomaticallyEnableed) {
        [self.ych_indexPathCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
            self.ych_indexPathCache.lengthsBySection[indexPath.section][indexPath.item] = @-1;
        }];
    }
    [self ych_reloadItemsAtIndexPaths:indexPaths];
}

- (void)ych_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    if (self.ych_indexPathCache.isAutomaticallyEnableed) {
        [self.ych_indexPathCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.ych_indexPathCache.lengthsBySection[indexPath.section] insertObject:@-1 atIndex:indexPath.item];
        }];
    }
    [self ych_insertItemsAtIndexPaths:indexPaths];
}

- (void)ych_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    if (self.ych_indexPathCache.isAutomaticallyEnableed) {
        [self.ych_indexPathCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        
        NSMutableDictionary<NSNumber *, NSMutableIndexSet *> *mutableIndexSetsToRemove = [NSMutableDictionary dictionary];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableIndexSet *mutableIndexSet = mutableIndexSetsToRemove[@(indexPath.section)];
            if (!mutableIndexSet) {
                mutableIndexSet = [NSMutableIndexSet indexSet];
                mutableIndexSetsToRemove[@(indexPath.section)] = mutableIndexSet;
            }
            [mutableIndexSet addIndex:indexPath.item];
        }];
        
        [mutableIndexSetsToRemove enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull sectionNumber, NSMutableIndexSet * _Nonnull indexSet, BOOL * _Nonnull stop) {
            [self.ych_indexPathCache.lengthsBySection[sectionNumber.integerValue] removeObjectsAtIndexes:indexSet];
        }];
    }
    [self ych_deleteItemsAtIndexPaths:indexPaths];
}

- (void)ych_moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath
{
    if (self.ych_indexPathCache.isAutomaticallyEnableed) {
        [self.ych_indexPathCache buildCachesAtIndexPathsIfNeeded:@[indexPath, newIndexPath]];
        YCHIndexPathLengthsBySection *cachedLengths = self.ych_indexPathCache.lengthsBySection;
        NSMutableArray<NSNumber *> *sourceItems = cachedLengths[indexPath.section];
        NSMutableArray<NSNumber *> *destinationItems = cachedLengths[newIndexPath.section];
        NSNumber *sourceValue = sourceItems[indexPath.item];
        NSNumber *destinationValue = destinationItems[newIndexPath.item];
        sourceItems[indexPath.item] = destinationValue;
        destinationItems[indexPath.item] = sourceValue;
    }
    [self ych_moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
}

- (NSMutableDictionary *)templeCells
{
    NSMutableDictionary *templeCells = objc_getAssociatedObject(self, _cmd);
    if (templeCells == nil) {
        templeCells = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, templeCells,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return templeCells;
}

//- (__kindof UICollectionViewCell *)templeCaculateCellForIdentifier:(NSString *)identifier
//{
//    
//}

@end
