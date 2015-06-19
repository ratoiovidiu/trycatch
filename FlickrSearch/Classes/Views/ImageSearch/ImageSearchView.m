//
//  ImageSearchView.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 19/06/15.
//
//

#import "ImageSearchView.h"

#import "UIDevice+Additions.h"
#import "UIScreen+Additions.h"

#define kTEXTFIED_WIDTH (IS_IPAD ? 350 : 200)
#define kTEXTFIED_HEIGHT (IS_IPAD ? 50 : 40)

#define kBUTTON_WIDTH   70
#define kBUTTON_HEIGHT  (IS_IPAD ? 40 : 36)

@interface ImageSearchView ()

@end

@implementation ImageSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        _ivBackground = [[UIImageView alloc] initWithFrame:CGRectZero];
        _ivBackground.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        _ivBackground.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_ivBackground];

        _tfSearch = [[UITextField alloc] initWithFrame:CGRectZero];
        _tfSearch.backgroundColor = [UIColor clearColor];
        _tfSearch.textAlignment = NSTextAlignmentCenter;
        _tfSearch.layer.backgroundColor = [[UIColor whiteColor] CGColor];
        _tfSearch.layer.borderColor = [[UIColor blackColor] CGColor];
        _tfSearch.layer.borderWidth = 2.0;
        _tfSearch.layer.cornerRadius = 10.0;
        _tfSearch.layer.masksToBounds = NO;
        _tfSearch.layer.shadowColor = [[UIColor whiteColor] CGColor];
        _tfSearch.layer.shadowOffset = CGSizeMake(5.0, 5.0);
        _tfSearch.layer.shadowOpacity = 1.0;
        _tfSearch.layer.shadowRadius = 10.0;
        [self addSubview:_tfSearch];

        _btnSearch = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnSearch.backgroundColor = [UIColor whiteColor];
        _btnSearch.layer.cornerRadius = 5.0;
        _btnSearch.layer.masksToBounds = NO;
        _btnSearch.layer.shadowColor = [[UIColor grayColor] CGColor];
        _btnSearch.layer.shadowOffset = CGSizeMake(5.0, 5.0);
        _btnSearch.layer.shadowOpacity = 1.0;
        _btnSearch.layer.shadowRadius = 10.0;
        [_btnSearch setTitleColor:[[UIColor blueColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [self addSubview:_btnSearch];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectIntersection([[UIScreen mainScreen] interfaceOrientationApplicationFrame], self.bounds);

    _ivBackground.frame = frame;

    _tfSearch.frame = CGRectMake(round((CGRectGetWidth(frame) - kTEXTFIED_WIDTH) / 2.0),
                                 round((CGRectGetHeight(frame) - kTEXTFIED_HEIGHT) / 3.0),
                                 kTEXTFIED_WIDTH,
                                 kTEXTFIED_HEIGHT);

    _btnSearch.frame = CGRectMake(round((CGRectGetWidth(frame) - kBUTTON_WIDTH) / 2.0),
                                  CGRectGetMaxY(_tfSearch.frame) + 10.0,
                                  kBUTTON_WIDTH,
                                  kBUTTON_HEIGHT);
}

@end
