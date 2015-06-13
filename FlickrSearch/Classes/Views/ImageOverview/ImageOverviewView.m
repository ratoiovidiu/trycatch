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

#define kLAYOUT_ITEM_WIDTH                  (IS_IPAD ? 200.0 : 100.0)
#define kLAYOUT_ITEM_HEIGHT                 (kLAYOUT_ITEM_WIDTH)

#define kLAYOUT_EDGE_INSET_TOP              (IS_IPAD ? 20.0 : 5.0)
#define kLAYOUT_EDGE_INSET_LEFT             (kLAYOUT_EDGE_INSET_TOP)
#define kLAYOUT_EDGE_INSET_BOTTOM           (kLAYOUT_EDGE_INSET_TOP)
#define kLAYOUT_EDGE_INSET_RIGHT            (kLAYOUT_EDGE_INSET_LEFT)

#define kLAYOUT_MIN_INTER_ITEM_SPACING      (IS_IPAD ? 15.0 : 5.0)
#define kLAYOUT_MIN_LINE_SPACING            (IS_IPAD ? 40.0 : 5.0)

@implementation ImageOverviewView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(kLAYOUT_ITEM_WIDTH, kLAYOUT_ITEM_HEIGHT);
        flowLayout.sectionInset = UIEdgeInsetsMake(kLAYOUT_EDGE_INSET_TOP, kLAYOUT_EDGE_INSET_LEFT, kLAYOUT_EDGE_INSET_BOTTOM, kLAYOUT_EDGE_INSET_RIGHT);
        flowLayout.minimumInteritemSpacing = kLAYOUT_MIN_INTER_ITEM_SPACING;
        flowLayout.minimumLineSpacing = kLAYOUT_MIN_LINE_SPACING;

        _cvImageOverview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _cvImageOverview.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        [self addSubview:_cvImageOverview];

        _ivFullImage = [[CustomImageView alloc] initWithFrame:CGRectZero];
        _ivFullImage.backgroundColor = [UIColor clearColor];
        _ivFullImage.zoomEnabled = YES;
        [self addSubview:_ivFullImage];

        _btnCloseDetailsLayout = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnCloseDetailsLayout setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
        [self addSubview:_btnCloseDetailsLayout];

        self.layoutType = LT_ListOnly;
    }

    return self;
}

- (void)setLayoutType:(ImageOverviewLayoutType)layoutType {
    _layoutType = layoutType;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectIntersection([[UIScreen mainScreen] interfaceOrientationApplicationFrame], self.bounds);

    switch (_layoutType) {
        case LT_ListOnly: {
            _cvImageOverview.frame = frame;
            _ivFullImage.frame = CGRectZero;
            _btnCloseDetailsLayout.frame = CGRectZero;

            // SETTING THE CORRECT FLOW-LAYOUT FOR COLLECTION-VIEW
            id objCollectionLayout = _cvImageOverview.collectionViewLayout;
            if (objCollectionLayout && (YES == [objCollectionLayout isKindOfClass:[UICollectionViewFlowLayout class]])) {
                UICollectionViewFlowLayout *flowLayout = objCollectionLayout;
                flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
                _cvImageOverview.collectionViewLayout = flowLayout;
            }
            break;
        }

        case LT_Details: {
            CGFloat cvWidth = round(CGRectGetWidth(frame));
            CGFloat cvHeight = round(kLAYOUT_ITEM_HEIGHT + kLAYOUT_EDGE_INSET_TOP + kLAYOUT_EDGE_INSET_BOTTOM + 2.0);

            _cvImageOverview.frame = CGRectMake(CGRectGetMinX(frame),
                                                CGRectGetMaxY(frame) - cvHeight,
                                                cvWidth,
                                                cvHeight);

            _ivFullImage.frame = CGRectMake(CGRectGetMinX(frame) + kLAYOUT_PADDING,
                                            CGRectGetMinY(frame) + kLAYOUT_PADDING,
                                            round(CGRectGetWidth(frame) - 2 * kLAYOUT_PADDING),
                                            round(CGRectGetMinY(_cvImageOverview.frame) - CGRectGetMinY(frame) - 2 * kLAYOUT_PADDING));

            CGFloat buttonSize = 40.0;
            _btnCloseDetailsLayout.frame = CGRectMake(CGRectGetMaxX(_ivFullImage.frame) - buttonSize,
                                                      CGRectGetMinY(_ivFullImage.frame),
                                                      buttonSize,
                                                      buttonSize);

            // SETTING THE CORRECT FLOW-LAYOUT FOR COLLECTION-VIEW
            id objCollectionLayout = _cvImageOverview.collectionViewLayout;
            if (objCollectionLayout && (YES == [objCollectionLayout isKindOfClass:[UICollectionViewFlowLayout class]])) {
                UICollectionViewFlowLayout *flowLayout = objCollectionLayout;
                flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                _cvImageOverview.collectionViewLayout = flowLayout;
            }

            break;
        }
    }
}

@end
