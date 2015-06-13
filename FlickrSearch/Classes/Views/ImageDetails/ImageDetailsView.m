//
//  ImageDetailsView.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 13/06/15.
//
//

#import "ImageDetailsView.h"

#import "UIScreen+Additions.h"

@implementation ImageDetailsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // TODO *
        self.backgroundColor = [UIColor clearColor];

        _ivCustom = [[CustomImageView alloc] initWithFrame:CGRectZero];
        _ivCustom.backgroundColor = [UIColor clearColor];
        [self addSubview:_ivCustom];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectIntersection([[UIScreen mainScreen] interfaceOrientationApplicationFrame], self.bounds);

    _ivCustom.frame = frame;
}

@end
