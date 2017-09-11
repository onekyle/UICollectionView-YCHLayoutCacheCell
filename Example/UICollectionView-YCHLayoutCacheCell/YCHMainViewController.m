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
@property (nonatomic, copy) YCHFeedModel *(^feedModelGenerator)();
@end

@implementation YCHMainViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Register cell classes
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.collectionView registerClass:[YCHFeedCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.ych_enforceFrameLayout = YES;
    if ([self.collectionView respondsToSelector:@selector(setPrefetchingEnabled:)]) {
        self.collectionView.prefetchingEnabled = NO;
    }
    ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize = CGSizeMake(self.collectionView.bounds.size.width, 50);
    _dataArr = [NSMutableArray array];
    int i = 0;
    NSArray *titlesArray = @[@"BTC",@"ETC",@"QTUM"];
    NSArray *contentTextArray = @[
                                  @"Bitcoin is a worldwide cryptocurrency and digital payment system called the first decentralized digital currency, since the system works without a central repository or single administrator. It was invented by an unknown programmer, or a group of programmers, under the name Satoshi Nakamoto and released as open-source software in 2009.[16] The system is peer-to-peer, and transactions take place between users directly, without an intermediary.[13]:4 These transactions are verified by network nodes and recorded in a public distributed ledger called a blockchain. \
                                  Besides being created as a reward for mining, bitcoin can be exchanged for other currencies, products, and services. As of February 2015, over 100,000 merchants and vendors accepted bitcoin as payment. Bitcoin can also be held as an investment. According to research produced by Cambridge University in 2017, there are 2.9 to 5.8 million unique users using a cryptocurrency wallet, most of them using bitcoin. On 1 August 2017 bitcoin split into two derivative digital currencies, the classic bitcoin (BTC) and the Bitcoin Cash (BCH).",
                                  @"Ethereum is an open-source, public, blockchain-based distributed computing platform featuring smart contract (scripting) functionality. It provides a decentralized Turing-complete virtual machine, the Ethereum Virtual Machine (EVM), which can execute scripts using an international network of public nodes. Ethereum also provides a cryptocurrency token called \"ether\", which can be transferred between accounts and used to compensate participant nodes for computations performed. \"Gas\", an internal transaction pricing mechanism, is used to mitigate spam and allocate resources on the network.\
                                  Ethereum was proposed in late 2013 by Vitalik Buterin, a cryptocurrency researcher and programmer. Development was funded by an online crowdsale during July–August 2014. The system went live on 30 July 2015.\
                                  In 2016 Ethereum was forked into two blockchains, as a result of the collapse of The DAO project, thereby creating Ethereum Classic.",
                                  @"Qtum makes it easier than ever for established sectors and legacy institutions to interface with blockchain technology. \
                                  Create your own tokens, automate supply chain management and engage in self-executing agreements in a standardized environment, verified and tested for stability.",
                                  ];
    NSArray *iconsArray = @[
                            [UIImage imageNamed:@"icon_0"],
                            [UIImage imageNamed:@"icon_1"],
                            [UIImage imageNamed:@"icon_2"],
                            ];
    
    _feedModelGenerator = ^YCHFeedModel *{
        YCHFeedModel *model = [YCHFeedModel new];
        model.title = titlesArray[arc4random() % titlesArray.count];
        model.text = contentTextArray[arc4random() % contentTextArray.count];
        model.icon = iconsArray[arc4random() % iconsArray.count];
        return model;
    };
    while (i != 20) {
        i++;
        [_dataArr addObject:_feedModelGenerator()];
    }
    
}

- (IBAction)didClickChangeLayout:(id)sender {
    
//    [self.collectionView setCollectionViewLayout:nil animated:YES];
}

- (IBAction)didClickAdd:(id)sender {
    YCHFeedModel *model = _feedModelGenerator();
    NSIndexPath *lastVisibleIndexPath = self.collectionView.indexPathsForVisibleItems.lastObject;
    [self.dataArr insertObject:model atIndex:lastVisibleIndexPath.item];
    [self.collectionView insertItemsAtIndexPaths:@[lastVisibleIndexPath]];
    [self.collectionView scrollToItemAtIndexPath:lastVisibleIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    return [collectionView ych_sizeForCellWithIdentifier:reuseIdentifier forIndexPath:indexPath fixedValue:((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize.width calculateType:YCHLayoutCacheCellCalculateTypeWith configuration:^(YCHFeedCell *cell) {
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
//    NSLog(@"%@",_dataArr[indexPath.item]);
}


@end
