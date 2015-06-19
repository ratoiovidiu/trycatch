//
//  CustomImageView.h
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 13/06/15.
//
//

#import <UIKit/UIKit.h>

#import "ImageDataModel.h"

@class CustomImageView;

@protocol CustomImageViewDelegate <NSObject>

@optional

- (void)imageTapped:(CustomImageView *)imageView;
- (void)imageDoubleTapped:(CustomImageView *)imageView;

- (void)displayPreviousImage:(CustomImageView *)imageView;
- (void)displayNextImage:(CustomImageView *)imageView;

@end


@interface CustomImageView : UIView

@property (nonatomic, assign) id<CustomImageViewDelegate> delegate;
@property (nonatomic, assign) BOOL zoomEnabled;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)displayImageWithInfo:(ImageDataModel *)imageInfo forSize:(ImageType)sizeType;

@end
