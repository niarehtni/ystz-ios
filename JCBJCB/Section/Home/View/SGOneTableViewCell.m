//
//  SGOneTableViewCell.m
//  JCBJCB
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "SGOneTableViewCell.h"
#import "SDCycleScrollView.h"
#import "JCBLoopModel.h"

@interface SGOneTableViewCell () <SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UIImageView *placehoder_imageView;
@end

@implementation SGOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.cycleScrollView = [[SDCycleScrollView alloc] init];
        _cycleScrollView.currentPageDotColor = [UIColor redColor];
        _cycleScrollView.pageDotColor = SGCommonBgColor;
        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.delegate = self;
        [self.contentView addSubview:_cycleScrollView];
    }
    return self;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(oneTableViewCell:didSelectItemAtIndex:)]) {
        [self.delegate oneTableViewCell:self didSelectItemAtIndex:index];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _cycleScrollView.frame = self.bounds;
}

- (void)setURLWithImage:(NSArray *)URLWithImage {
    _URLWithImage = URLWithImage;
    if (URLWithImage.count == 0) {
        if (_placehoder_imageView == nil) {
            self.placehoder_imageView = [[UIImageView alloc] init];
            _placehoder_imageView.image = [UIImage imageNamed:@"placeholder"];
            _placehoder_imageView.frame = CGRectMake(0, 0, SG_screenWidth, loopScrollViewHeight);
            [self addSubview:_placehoder_imageView];
        }
    } else {
        [_placehoder_imageView removeFromSuperview];
        _placehoder_imageView = nil;
        
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        _cycleScrollView.imageURLStringsGroup = URLWithImage;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
