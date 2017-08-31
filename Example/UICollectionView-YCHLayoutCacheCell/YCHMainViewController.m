//
//  YCHMainViewController.m
//  UICollectionView-YCHLayoutCacheCell
//
//  Created by Kyle on 28/8/17.
//  Copyright © 2017年 ych.wang@outlook.com. All rights reserved.
//

#import "YCHMainViewController.h"
#import "UICollectionView+YCHLayoutCacheCell.h"

@interface YCHMainViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation YCHMainViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.ych_enforceFrameLayout = YES;
    if ([self.collectionView respondsToSelector:@selector(setPrefetchingEnabled:)]) {
        self.collectionView.prefetchingEnabled = NO;
    }
    
    _dataArr = [NSMutableArray array];
    int i = 0;
    while (i != 100) {
        [_dataArr addObject:[NSString stringWithFormat:@"Test title : %d",i++]];
    }
    
}

- (IBAction)didClickChangeLayout:(id)sender {
    
//    [self.collectionView setCollectionViewLayout:nil animated:YES];
}

- (IBAction)didClickAdd:(id)sender {
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView ych_sizeForCellWithIdentifier:reuseIdentifier forIndexPath:indexPath fixedValue:self.view.bounds.size.width calculateType:YCHLayoutCacheCellCalculateTypeWith configuration:^(id cell) {
        
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [self randomColor];
    
    return cell;
}

- (UIColor *)randomColor
{
    CGFloat r  = (arc4random() % 256) / 255.0;
    CGFloat g = (arc4random() % 256) / 255.0;
    CGFloat b = (arc4random() % 256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",_dataArr[indexPath.item]);
}


@end
