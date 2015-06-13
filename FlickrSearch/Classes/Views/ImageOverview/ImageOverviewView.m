//
//  ImageOverviewView.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 11/06/15.
//
//

#import "ImageOverviewView.h"

#import "UIScreen+Additions.h"

#define kLAYOUT_EDGE_INSET_TOP                (IS_IPAD ? 20.0 : 5.0)
#define kLAYOUT_EDGE_INSET_LEFT               (kLAYOUT_EDGE_INSET_TOP)
#define kLAYOUT_EDGE_INSET_BOTTOM             (kLAYOUT_EDGE_INSET_TOP)
#define kLAYOUT_EDGE_INSET_RIGHT              (kLAYOUT_EDGE_INSET_LEFT)

#define kLAYOUT_MIN_INTER_ITEM_SPACING        (IS_IPAD ? 25.0 : 5.0)
#define kLAYOUT_MIN_LINE_SPACING              (IS_IPAD ? 40.0 : 5.0)

@implementation ImageOverviewView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(kLAYOUT_ITEM_WIDTH, kLAYOUT_ITEM_HEIGHT);
        flowLayout.sectionInset = UIEdgeInsetsMake(kLAYOUT_EDGE_INSET_TOP, kLAYOUT_EDGE_INSET_LEFT, kLAYOUT_EDGE_INSET_BOTTOM, kLAYOUT_EDGE_INSET_RIGHT);
        flowLayout.minimumInteritemSpacing = kLAYOUT_MIN_INTER_ITEM_SPACING;
        flowLayout.minimumLineSpacing = kLAYOUT_MIN_LINE_SPACING;

        _cvImageOverview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _cvImageOverview.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];

        [self addSubview:_cvImageOverview];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectIntersection([[UIScreen mainScreen] interfaceOrientationApplicationFrame], self.bounds);

    NSLog(@"TODO * %@", NSStringFromCGRect(frame));
    _cvImageOverview.frame = frame;
}

@end
