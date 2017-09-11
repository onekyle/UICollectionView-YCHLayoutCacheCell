//
//  YCHFeedCell.m
//  UICollectionView-YCHLayoutCacheCell
//
//  Created by Kyle on 11/9/17.
//  Copyright © 2017年 ych.wang@outlook.com. All rights reserved.
//

#import "YCHFeedCell.h"

@interface YCHFeedCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation YCHFeedCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        
        _iconImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImgView];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)setModel:(YCHFeedModel *)model
{
    _titleLabel.text = model.title;
    _contentLabel.text = model.text;
    _iconImgView.image = model.icon;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    _titleLabel.frame = CGRectMake(15, 10, 80, 20);
    if (_iconImgView.image) {
        CGFloat maxImgW = size.width - 30;
        if (_iconImgView.image.size.width > maxImgW) {
            _iconImgView.frame = CGRectMake(15, 40, maxImgW, _iconImgView.image.size.height / _iconImgView.image.size.width * maxImgW);
        } else {
            _iconImgView.frame = CGRectMake(15, 40, _iconImgView.image.size.width, _iconImgView.image.size.height);
        }
    } else {
        _iconImgView.frame = _titleLabel.frame;
    }
    
    CGFloat contentLabelWith = size.width - 30;
    CGFloat contentLabelHeight = [_contentLabel.text boundingRectWithSize:CGSizeMake(contentLabelWith, 999) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_contentLabel.font} context:nil].size.height;
    _contentLabel.frame = CGRectMake(15, CGRectGetMaxY(_iconImgView.frame) + 10, contentLabelWith, contentLabelHeight);
    
    return CGSizeMake(size.width, CGRectGetMaxY(_contentLabel.frame) + 10);
}

@end
