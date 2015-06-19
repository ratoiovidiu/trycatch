//
//  ImageSearchController.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 19/06/15.
//
//

#import "ImageSearchController.h"
#import "ImageSearchView.h"

#import "ImageOverviewController.h"

@interface ImageSearchController ()

@end

@implementation ImageSearchController

- (void)loadView {
    ImageSearchView *pageView = [[ImageSearchView alloc] initWithFrame:CGRectZero];
    pageView.ivBackground.image = [UIImage imageNamed:@"background.png"];

    [pageView.btnSearch setTitle:NSLocalizedString(@"Search", nil) forState:UIControlStateNormal];
    [pageView.btnSearch addTarget:self action:@selector(btnSearch_Touched) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopTextEditing)];
    [pageView.ivBackground addGestureRecognizer:tapGesture];
    pageView.ivBackground.userInteractionEnabled = YES;

    self.view = pageView;
}

- (void)stopTextEditing {
    ImageSearchView *pageView = (ImageSearchView *)self.view;
    [pageView.tfSearch resignFirstResponder];
}

- (void)btnSearch_Touched {
    ImageSearchView *pageView = (ImageSearchView *)self.view;
    NSString *searchText = [pageView.tfSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (0 != searchText.length) {
        [self stopTextEditing];

        ImageOverviewController *ctrl = [[ImageOverviewController alloc] init];
        ctrl.searchText = searchText;
        [self.navigationController pushViewController:ctrl animated:YES];

        NSLog(@"TODO * started Search");
    }
}

@end
