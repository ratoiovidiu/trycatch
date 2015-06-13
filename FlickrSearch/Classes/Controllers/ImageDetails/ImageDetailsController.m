//
//  ImageDetailsController.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 13/06/15.
//
//

#import "ImageDetailsController.h"

#import "ImageDetailsView.h"

@interface ImageDetailsController ()

@end

@implementation ImageDetailsController

- (void)loadView {
    ImageDetailsView *pageView = [[ImageDetailsView alloc] initWithFrame:CGRectZero];


    self.view = pageView;
}

- (void)displayImage:(ImageDataModel *)imageInfo {
    ImageDetailsView *pageView = (ImageDetailsView *)self.view;
    [pageView.ivCustom displayImageWithInfo:imageInfo forSize:IT_Large];
}

@end
