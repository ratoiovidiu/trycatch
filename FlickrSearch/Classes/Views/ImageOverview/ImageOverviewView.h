//
//  ImageOverviewView.h
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 11/06/15.
//
//

#import <UIKit/UIKit.h>

#import "UIDevice+Additions.h"

#define kLAYOUT_ITEM_WIDTH                    (IS_IPAD ? 200.0 : 100.0)
#define kLAYOUT_ITEM_HEIGHT                   (kLAYOUT_ITEM_WIDTH)

@interface ImageOverviewView : UIView

@property (nonatomic, strong) UICollectionView *cvImageOverview;

- (instancetype)initWithFrame:(CGRect)frame;

@end
