//
//  ImageOverviewController.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 10/06/15.
//
//

#import "ImageOverviewController.h"

#import "ImageOverviewView.h"
#import "WebServiceManager.h"

@interface ImageOverviewController ()

@end

@implementation ImageOverviewController

- (void)loadView {
    ImageOverviewView *pageView = [[ImageOverviewView alloc] initWithFrame:CGRectZero];
    self.view = pageView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[WebServiceManager shared] getPhotoListWithTag:@"Party" forPageNumber:1 usingCallback:^(id response, NSError *error) {
        NSLog(@"TODO * %@", error);
    }];
}

@end
