//
//  ImageOverviewView.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 11/06/15.
//
//

#import "ImageOverviewView.h"

#import "UIScreen+Additions.h"

#define kLAYOUT_PADDING                     10.0

#define kLAYOUT_SMALL_ITEM                  (IS_IPAD ? 100.0 : 60.0)

#define kLAYOUT_NORMAL_ITEM                 (IS_IPAD ? 200.0 : 100.0)
#define kLAYOUT_EDGE_INSET                  (IS_IPAD ? 20.0 : 5.0)
#define kLAYOUT_MIN_INTER_ITEM_SPACING      (IS_IPAD ? 15.0 : 5.0)

@implementation ImageOverviewView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];

        _ivFullImage = [[CustomImageView alloc] initWithFrame:CGRectZero];
        _ivFullImage.backgroundColor = [UIColor clearColor];
        _ivFullImage.zoomEnabled = YES;
        [self addSubview:_ivFullImage];

        _cvImageOverview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _cvImageOverview.backgroundColor = [UIColor clearColor];
        [self addSubview:_cvImageOverview];

        _btnCloseDetailsLayout = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnCloseDetailsLayout setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
        _btnCloseDetailsLayout.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        [self addSubview:_btnCloseDetailsLayout];

        _layoutType = LT_Details;
        self.layoutType = LT_ListOnly;
    }

    return self;
}

- (void)setLayoutType:(ImageOverviewLayoutType)layoutType {
    [self setLayoutType:layoutType animated:NO];
}

- (void)setLayoutType:(ImageOverviewLayoutType)layoutType animated:(BOOL)animated {
    [self setLayoutType:layoutType animated:animated completion:NULL];
}

- (void)setLayoutType:(ImageOverviewLayoutType)layoutType animated:(BOOL)animated completion:(void (^)())completion {
    _cvImageOverview.hidden = NO;

    if (layoutType == _layoutType) {
        if (completion) {
            completion();
        }
        return;
    }

    _layoutType = layoutType;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    switch (_layoutType) {
        case LT_ListOnly: {
            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            flowLayout.itemSize = CGSizeMake(kLAYOUT_NORMAL_ITEM, kLAYOUT_NORMAL_ITEM);
            flowLayout.sectionInset = UIEdgeInsetsMake(kLAYOUT_EDGE_INSET, kLAYOUT_EDGE_INSET, kLAYOUT_EDGE_INSET, kLAYOUT_EDGE_INSET);
            flowLayout.minimumInteritemSpacing = kLAYOUT_MIN_INTER_ITEM_SPACING;
            flowLayout.minimumLineSpacing = kLAYOUT_MIN_INTER_ITEM_SPACING;

            break;
        }

        case LT_Details: {
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.itemSize = CGSizeMake(kLAYOUT_SMALL_ITEM, kLAYOUT_SMALL_ITEM);
            flowLayout.sectionInset = UIEdgeInsetsZero;
            flowLayout.minimumInteritemSpacing = kLAYOUT_MIN_INTER_ITEM_SPACING;
            flowLayout.minimumLineSpacing = kLAYOUT_MIN_INTER_ITEM_SPACING;

            break;
        }
    }

    if (animated) {
        CGFloat animationDuration = 0.1;

        CGRect originFrame = _cvImageOverview.frame;
        CGFloat maxHeight = round(CGRectGetHeight(self.bounds) * 1.05);

        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect newFrame = originFrame;
            newFrame.origin.y = maxHeight;

            weakSelf.cvImageOverview.frame = newFrame;
        } completion:^(BOOL finished) {
            [weakSelf.cvImageOverview setCollectionViewLayout:flowLayout animated:NO completion:^(BOOL finished) {
                [weakSelf.cvImageOverview.collectionViewLayout invalidateLayout];
                [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [weakSelf layoutSubviews];
                } completion:^(BOOL finished) {
                    [weakSelf.cvImageOverview reloadData];
                    [weakSelf setNeedsLayout];

                    if (completion) {
                        completion();
                    }
                }];
            }];
        }];
    } else {
        _cvImageOverview.collectionViewLayout = flowLayout;
        [_cvImageOverview reloadData];
        [self setNeedsLayout];

        if (completion) {
            completion();
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectIntersection([[UIScreen mainScreen] interfaceOrientationApplicationFrame], self.bounds);

    switch (_layoutType) {
        case LT_ListOnly: {
            _cvImageOverview.frame = CGRectMake(CGRectGetMinX(frame),
                                                CGRectGetMinY(frame) + 44.0,
                                                CGRectGetWidth(frame),
                                                CGRectGetHeight(frame) - 44.0);
            _cvImageOverview.backgroundColor = [UIColor clearColor];
            _ivFullImage.frame = CGRectZero;
            _btnCloseDetailsLayout.frame = CGRectZero;
            break;
        }

        case LT_Details: {
            CGFloat cvWidth = round(CGRectGetWidth(frame));
            CGFloat cvHeight = round(kLAYOUT_SMALL_ITEM + 2 * kLAYOUT_MIN_INTER_ITEM_SPACING);

            _cvImageOverview.frame = CGRectMake(CGRectGetMinX(frame),
                                                CGRectGetMaxY(frame) - cvHeight,
                                                cvWidth,
                                                cvHeight);
            _cvImageOverview.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];

            _ivFullImage.frame = CGRectInset(frame, 10.0, 10.0);

            CGFloat buttonSize = 40.0;
            _btnCloseDetailsLayout.frame = CGRectMake(CGRectGetMaxX(_ivFullImage.frame) - buttonSize,
                                                      CGRectGetMinY(_ivFullImage.frame),
                                                      buttonSize,
                                                      buttonSize);
            _btnCloseDetailsLayout.layer.cornerRadius = round(buttonSize * 0.5);
            break;
        }
    }
}

@end
