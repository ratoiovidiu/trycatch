//
//  CustomImageView.h
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 13/06/15.
//
//

#import <UIKit/UIKit.h>

#import "ImageDataModel.h"

@interface CustomImageView : UIView

@property (nonatomic, assign) BOOL zoomEnabled;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)displayImageWithInfo:(ImageDataModel *)imageInfo forSize:(ImageType)sizeType;

@end
