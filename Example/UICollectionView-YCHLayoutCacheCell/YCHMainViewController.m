//
//  YCHMainViewController.m
//  UICollectionView-YCHLayoutCacheCell
//
//  Created by Kyle on 28/8/17.
//  Copyright © 2017年 ych.wang@outlook.com. All rights reserved.
//

#import "YCHMainViewController.h"
#import "UICollectionView+YCHLayoutCacheCell.h"
#import "YCHFeedModel.h"
#import "YCHFeedCell.h"

@interface YCHMainViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray<YCHFeedModel *> *dataArr;
@end

@implementation YCHMainViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Register cell classes
    [self.collectionView registerClass:[YCHFeedCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.ych_enforceFrameLayout = YES;
    if ([self.collectionView respondsToSelector:@selector(setPrefetchingEnabled:)]) {
        self.collectionView.prefetchingEnabled = NO;
    }
    _dataArr = [NSMutableArray array];
    int i = 0;
    NSArray *titlesArray = @[@"BTC",@"ETC",@"QTUM"];
    NSArray *contentTextArray = @[
                                  @"test1",
                                  @"test2",
                                  @"test3",
                                  ];
    NSArray *iconsArray = @[];
    while (i != 20) {
        i++;
        YCHFeedModel *model = [YCHFeedModel new];
        model.title = titlesArray[arc4random() % titlesArray.count];
        model.text = contentTextArray[arc4random() % contentTextArray.count];
//        model.icon = iconsArray[arc4random() % iconsArray.count];
        [_dataArr addObject:model];
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
    NSLog(@"load height for cell : %@",indexPath);
    __weak typeof(self) weakSelf = self;
    return [collectionView ych_sizeForCellWithIdentifier:reuseIdentifier forIndexPath:indexPath fixedValue:self.view.bounds.size.width calculateType:YCHLayoutCacheCellCalculateTypeWith configuration:^(YCHFeedCell *cell) {
        cell.model = weakSelf.dataArr[indexPath.item];
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"has loaded cell for index: %@",indexPath);
    YCHFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];
    
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
