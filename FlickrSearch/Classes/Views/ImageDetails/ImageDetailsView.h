//
//  ImageDetailsView.h
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 13/06/15.
//
//

#import <UIKit/UIKit.h>

#import "CustomImageView.h"

@interface ImageDetailsView : UIView

@property (nonatomic, strong) CustomImageView *ivCustom;

- (instancetype)initWithFrame:(CGRect)frame;

@end
