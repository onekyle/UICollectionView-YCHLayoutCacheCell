//
//  UICollectionView+YCHLayoutCacheCell.m
//  Pods
//
//  Created by Kyle on 27/8/17.
//
//

#import "UICollectionView+YCHLayoutCacheCell.h"
#import "UICollectionView+YCHIndexPathCache.h"
#import "UICollectionView+YCHKeyedCache.h"

#ifndef YCHDebugLog

#ifdef DEBUG
#define YCHDebugLog(fmt, ...) \
NSLog(@"INFO: %@(%d)\n%s: " fmt , [[NSString stringWithUTF8String:__FILE__] lastPathComponent], \
__LINE__, \
__PRETTY_FUNCTION__,## __VA_ARGS__)
#else
#define YCHDebugLog(...)   ;
#endif

#endif


@implementation UICollectionView (YCHLayoutCacheCell)

- (__kindof UICollectionViewCell *)ych_templateCellForReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
//    NSAssert(identifier.length > 0, @"Expect a valid identifier - %@", identifier);
//    
//    if (<#condition#>) {
//        <#statements#>
//    }
//    
//    UICollectionViewCell *templateCell = self.tempCells[identifier];
//    if (!templateCell) {
//        
//    }
    return nil;
}

- (CGSize)ych_sizeForCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id cell))configuration
{
    
}

- (CGSize)ych_sizeForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id cell))configuration
{
    if (!identifier || !indexPath) {
        YCHDebugLog(@"invaild identifier or indexPath");
        return CGSizeZero;
    }
    
    if ([self.ych_indexPathCache existsSizeAtIndexPath:indexPath]) {
        YCHDebugLog(@"%@",[NSString stringWithFormat:@"hit cache size for indexPath[%zd:%zd] - size%@", indexPath.section, indexPath.item, NSStringFromCGSize([self.ych_indexPathCache sizeForIndexPath:indexPath])]);
        return [self.ych_indexPathCache sizeForIndexPath:indexPath];
    }
    
    CGSize size = [self ych_sizeForCellWithIdentifier:identifier forIndexPath:indexPath configuration:configuration];
    [self.ych_indexPathCache cacheSize:size byIndexPath:indexPath];
    YCHDebugLog(@"%@",[NSString stringWithFormat:@"cache size for indexPath[%zd:%zd] - size%@", indexPath.section, indexPath.item, NSStringFromCGSize(size)]);
    
    return size;
}

- (CGSize)ych_sizeForCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath cacheByKey:(id<NSCopying>)key configuration:(void (^)(id cell))configuration
{
    
}

@end
