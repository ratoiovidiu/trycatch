//
//  ImageCollectionViewCell.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 12/06/15.
//
//

#import "ImageCollectionViewCell.h"

@interface ImageCollectionViewCell ()

@end

@implementation ImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];

        _ivCustom = [[CustomImageView alloc] initWithFrame:CGRectZero];
        _ivCustom.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_ivCustom];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _ivCustom.frame = self.bounds;
}

@end
