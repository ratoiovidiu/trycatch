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

#import "PhotoInfo.h"

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
        if ((nil == error) && (YES == [response isKindOfClass:[NSDictionary class]])) {
            // NSNumber *currentPage = [response objectForKey:@"currentPage"];
            // NSNumber *totalPages = [response objectForKey:@"totalPages"];
            NSArray *arrPhotoList = [response objectForKey:@"arrPhotoList"];
            for (PhotoInfo *photoInfo in arrPhotoList) {
                NSLog(@"Title: '%@' \n * %@ \n * %@ \n * %@ \n * %@\n\n",
                      photoInfo.title,
                      photoInfo.thumbUrlString,
                      photoInfo.smallUrlString,
                      photoInfo.largeUrlString,
                      photoInfo.defaultUrlString);
            }
        }
    }];
}

@end
