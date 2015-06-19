//
//  ImageOverviewView.h
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 11/06/15.
//
//

#import <UIKit/UIKit.h>

#import "CustomImageView.h"
#import "UIDevice+Additions.h"

typedef NS_ENUM(NSInteger, ImageOverviewLayoutType) {
    LT_ListOnly = 0,
    LT_Details
};


@interface ImageOverviewView : UIView

@property (nonatomic, assign) ImageOverviewLayoutType layoutType;

@property (nonatomic, strong) UICollectionView *cvImageOverview;
@property (nonatomic, strong) UIButton *btnCloseDetailsLayout;
@property (nonatomic, strong) CustomImageView *ivFullImage;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setLayoutType:(ImageOverviewLayoutType)layoutType animated:(BOOL)animated;
- (void)setLayoutType:(ImageOverviewLayoutType)layoutType animated:(BOOL)animated completion:(void (^)())completion;

@end
