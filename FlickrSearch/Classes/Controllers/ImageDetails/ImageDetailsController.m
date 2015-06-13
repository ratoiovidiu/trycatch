//
//  ImageDetailsController.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 13/06/15.
//
//

#import "ImageDetailsController.h"

#import "ImageDetailsView.h"

@interface ImageDetailsController () <UIGestureRecognizerDelegate>

@end

@implementation ImageDetailsController

- (void)loadView {
    ImageDetailsView *pageView = [[ImageDetailsView alloc] initWithFrame:CGRectZero];

    UISwipeGestureRecognizer *swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    swipeDownGestureRecognizer.delegate = self;
    [pageView addGestureRecognizer:swipeDownGestureRecognizer];

    UISwipeGestureRecognizer *swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp)];
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    swipeUpGestureRecognizer.delegate = self;
    [pageView addGestureRecognizer:swipeUpGestureRecognizer];

    self.view = pageView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)displayImage:(ImageDataModel *)imageInfo {
    ImageDetailsView *pageView = (ImageDetailsView *)self.view;
    [pageView.ivCustom displayImageWithInfo:imageInfo forSize:IT_Large];
}

- (void)handleSwipeDown {
    if (YES == self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)handleSwipeUp {
    if (NO == self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
