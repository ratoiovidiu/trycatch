//
//  ImageOverviewController.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 10/06/15.
//
//

#import "ImageOverviewController.h"

#import "ImageOverviewView.h"

@interface ImageOverviewController ()

@end

@implementation ImageOverviewController

- (void)loadView {
    ImageOverviewView *pageView = [[ImageOverviewView alloc] initWithFrame:CGRectZero];
    self.view = pageView;
}

@end
