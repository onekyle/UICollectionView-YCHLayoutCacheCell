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
#import <objc/runtime.h>

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

- (CGSize)ych_systemFittingSize:(CGSize)size
                  calculateType:(YCHLayoutCacheCellCalculateType)calculateType
            forConfiguratedCell:(__kindof UICollectionViewCell *)cell
{
    CGSize calculatedSize = CGSizeZero;
    
    if (self.ych_enforceFrameLayout) {
#if DEBUG
        if (cell.contentView.constraints.count > 0) {
            NSLog(@"Cannot get a proper cell height (now 0) from '- systemFittingSize:'(AutoLayout). You should check how constraints are built in cell, making it into 'self-sizing' cell.");
        }
#endif
        calculatedSize = [cell sizeThatFits:size];
    } else {
        if (calculateType == YCHLayoutCacheCellCalculateTypeWith || calculateType == YCHLayoutCacheCellCalculateTypeHeight) {
            
            NSLayoutAttribute attribute;
            CGFloat constant;
            if (calculateType == YCHLayoutCacheCellCalculateTypeWith) {
                attribute = NSLayoutAttributeWidth;
                constant = size.width;
            } else {
                attribute = NSLayoutAttributeHeight;
                constant = size.height;
            }
            
            NSLayoutConstraint *tempConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:attribute relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:constant];
            [cell.contentView addConstraint:tempConstraint];
            calculatedSize = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            [cell.contentView removeConstraint:tempConstraint];
            
        } else if (calculateType == YCHLayoutCacheCellCalculateTypeSize) {
            
            calculatedSize = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            
        } else {
            YCHDebugLog(@"Please set a vaild YCHLayoutCacheCellCalculateType");
        }
    }

    return calculatedSize;
}

- (CGSize)ych_sizeForCellWithIdentifier:(NSString *)identifier
                           forIndexPath:(NSIndexPath *)indexPath
                              fixedSize:(CGSize)fixedSize
                          configuration:(void (^)(id cell))configuration
{
    if (!identifier) {
        YCHDebugLog(@"invaild identifier");
        return CGSizeZero;
    }
    
    UICollectionViewCell *cell = self.tempCells[identifier];
    configuration(cell);
    
    return [self ych_systemFittingSize:fixedSize calculateType:YCHLayoutCacheCellCalculateTypeSize forConfiguratedCell:cell];
}

- (CGSize)ych_sizeForCellWithIdentifier:(NSString *)identifier
                             cacheByKey:(id<NSCopying>)key
                             fixedValue:(CGFloat)fixedValue
                          calculateType:(YCHLayoutCacheCellCalculateType)calculateType
                          configuration:(void (^)(id cell))configuration
{
    if (!identifier || !key) {
        YCHDebugLog(@"invaild identifier or key");
        return CGSizeZero;
    }
    
    if ([self.ych_keyedSizeCache existsSizeForKey:key]) {
        YCHDebugLog(@"%@",[NSString stringWithFormat:@"hit cache size for key[%@] - size%@", key, NSStringFromCGSize([self.ych_keyedSizeCache sizeForKey:key])]);
        return [self.ych_keyedSizeCache sizeForKey:key];
    }
    
    CGSize fittingSize = CGSizeMake(fixedValue, fixedValue);
    UICollectionViewCell *cell = self.tempCells[identifier];
    configuration(cell);
    
    CGSize calculatedSize = [self ych_systemFittingSize:fittingSize calculateType:calculateType forConfiguratedCell:cell];
    
    [self.ych_keyedSizeCache cacheSize:calculatedSize forKey:key];
    YCHDebugLog(@"%@",[NSString stringWithFormat:@"cache size for key[%@] - size%@", key, NSStringFromCGSize(calculatedSize)]);
    
    return calculatedSize;
}

- (CGSize)ych_sizeForCellWithIdentifier:(NSString *)identifier
                           forIndexPath:(NSIndexPath *)indexPath
                             fixedValue:(CGFloat)fixedValue
                          calculateType:(YCHLayoutCacheCellCalculateType)calculateType
                          configuration:(void (^)(id cell))configuration
{
    if (!identifier || !indexPath) {
        YCHDebugLog(@"invaild identifier or indexPath");
        return CGSizeZero;
    }
    
    if ([self.ych_indexPathCache existsSizeAtIndexPath:indexPath]) {
        YCHDebugLog(@"%@",[NSString stringWithFormat:@"hit cache size for indexPath[%zd:%zd] - size%@", indexPath.section, indexPath.item, NSStringFromCGSize([self.ych_indexPathCache sizeForIndexPath:indexPath])]);
        return [self.ych_indexPathCache sizeForIndexPath:indexPath];
    }
    
    CGSize fittingSize = CGSizeMake(fixedValue, fixedValue);
    UICollectionViewCell *cell = self.tempCells[identifier];
    configuration(cell);
    
    CGSize calculatedSize = [self ych_systemFittingSize:fittingSize calculateType:calculateType forConfiguratedCell:cell];
    
    [self.ych_indexPathCache cacheSize:calculatedSize forIndexPath:indexPath];
    YCHDebugLog(@"%@",[NSString stringWithFormat:@"cache size for indexPath[%zd:%zd] - size%@", indexPath.section, indexPath.item, NSStringFromCGSize(calculatedSize)]);
    
    return calculatedSize;
}


- (void)setYch_enforceFrameLayout:(BOOL)ych_enforceFrameLayout
{
    objc_setAssociatedObject(self, @selector(ych_enforceFrameLayout), @(ych_enforceFrameLayout), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)ych_enforceFrameLayout
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setYch_isTempLayoutCell:(BOOL)ych_isTempLayoutCell
{
    objc_setAssociatedObject(self, @selector(ych_isTempLayoutCell), @(ych_isTempLayoutCell), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)ych_isTempLayoutCell
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
