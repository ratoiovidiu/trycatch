//
//  ImageOverviewController.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 10/06/15.
//
//

#import "ImageOverviewController.h"

#import "ImageDataModel.h"
#import "WebServiceManager.h"

#import "ImageOverviewView.h"
#import "ImageCollectionViewCell.h"

#define kIMAGE_COLLECTION_VIEW_CELL_KEY @"IMAGE_COLLECTION_VIEW_CELL_KEY"

@interface ImageOverviewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CustomImageViewDelegate>

@property (nonatomic, assign) NSInteger imageDataTotalPages;
@property (nonatomic, assign) NSInteger imageDataCurrentPage;
@property (nonatomic, assign) NSInteger imageDataNextRequestedPage;

@property (nonatomic, retain) NSMutableArray *imageDataElementsList;

@end

@implementation ImageOverviewController

- (void)loadView {
    ImageOverviewView *pageView = [[ImageOverviewView alloc] initWithFrame:CGRectZero];

    pageView.ivFullImage.delegate = self;

    pageView.cvImageOverview.dataSource = self;
    pageView.cvImageOverview.delegate = self;
    [pageView.cvImageOverview registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:kIMAGE_COLLECTION_VIEW_CELL_KEY];

    [pageView.btnCloseDetailsLayout addTarget:self action:@selector(btnCloseDetailsLayout_Touched) forControlEvents:UIControlEventTouchUpInside];

    self.imageDataElementsList = [NSMutableArray array];

    self.view = pageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf btnFetchData_Touched];
    });
}

- (void)btnFetchData_Touched {
    self.imageDataNextRequestedPage = NSIntegerMin;
    self.imageDataCurrentPage = 0;
    self.imageDataTotalPages = NSIntegerMax;

    [self.imageDataElementsList removeAllObjects];

    ImageOverviewView *pageView = (ImageOverviewView *)self.view;
    [pageView.cvImageOverview reloadData];

    [self downloadLiveDataForPage:self.imageDataCurrentPage];
}

#pragma mark - Private Methods

- (void)downloadLiveDataForPage:(NSInteger)currentPage {
    NSInteger nextPageNumber = (1 + currentPage);
    if (self.imageDataNextRequestedPage < nextPageNumber) {
        self.imageDataNextRequestedPage = nextPageNumber;

        __weak typeof(self) weakSelf = self;
        [[WebServiceManager shared] getPhotoListWithTag:self.searchText
                                          forPageNumber:nextPageNumber
                                          usingCallback:^(id response, NSError *error) {
                                              if ((nil == error) && (YES == [response isKindOfClass:[NSDictionary class]])) {
                                                  [weakSelf processLiveDataElementList:response];
                                              } else {
                                                  self.imageDataNextRequestedPage = NSIntegerMin;
                                                  NSLog(@"ERROR: %@", [error localizedDescription]);
                                              }
                                          }];
    }
}

- (void)processLiveDataElementList:(NSDictionary *)response {
    NSInteger currentPage = [[response objectForKey:@"currentPage"] integerValue];
    NSInteger totalPages = [[response objectForKey:@"totalPages"] integerValue];
    NSArray *arrPhotoList = [NSArray arrayWithArray:[response objectForKey:@"arrPhotoList"]];

    if ((0 == currentPage) || (0 == totalPages)) {
        NSLog(@"We have encountered a communication error. Please try again later.");
    } else if ((0 == arrPhotoList.count) && (totalPages != currentPage)) {
        NSLog(@"Received response is invalid");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self downloadLiveDataForPage:self.imageDataCurrentPage];
        });
    } else {
        self.imageDataTotalPages = totalPages;
        self.imageDataCurrentPage = currentPage;
        self.imageDataNextRequestedPage = NSIntegerMin;

        [self.imageDataElementsList addObjectsFromArray:arrPhotoList];
    }

    ImageOverviewView *pageView = (ImageOverviewView *)self.view;
    [pageView.cvImageOverview reloadData];
}

#pragma mark - UIButton actions

- (void)btnCloseDetailsLayout_Touched {
    __weak ImageOverviewView *pageView = (ImageOverviewView *)self.view;

    NSIndexPath *selectedIndex = nil;
    NSArray *selectedItems = [pageView.cvImageOverview indexPathsForSelectedItems];
    if (0 != selectedItems.count) {
        selectedIndex = [selectedItems firstObject];
    }

    [pageView setLayoutType:LT_ListOnly animated:YES completion:^{
        if (nil != selectedIndex) {
            [pageView.cvImageOverview scrollToItemAtIndexPath:selectedIndex
                                             atScrollPosition:(UICollectionViewScrollPositionCenteredVertically | UICollectionViewScrollPositionCenteredHorizontally)
                                                     animated:NO];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger numberOfSection = 1;
    ImageOverviewView *pageView = (ImageOverviewView *)self.view;

    if (collectionView == pageView.cvImageOverview) {
        numberOfSection = 1;
    }

    return numberOfSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItems = 0;
    ImageOverviewView *pageView = (ImageOverviewView *)self.view;

    if (collectionView == pageView.cvImageOverview) {
        numberOfItems = self.imageDataElementsList.count;
    }

    return numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    ImageOverviewView *pageView = (ImageOverviewView *)self.view;

    if (collectionView == pageView.cvImageOverview) {
        if (self.imageDataCurrentPage < self.imageDataTotalPages) {
            if ((0 != self.imageDataElementsList.count) && (ABS([collectionView numberOfItemsInSection:indexPath.section] - indexPath.item) < 20)) {
                [self downloadLiveDataForPage:self.imageDataCurrentPage];
            }
        }

        if (nil == cell) {
            if (indexPath.item < self.imageDataElementsList.count) {
                id imageInfo = [self.imageDataElementsList objectAtIndex:indexPath.item];
                if (imageInfo && (YES == [imageInfo isKindOfClass:[ImageDataModel class]])) {
                    ImageCollectionViewCell *customCell = [collectionView dequeueReusableCellWithReuseIdentifier:kIMAGE_COLLECTION_VIEW_CELL_KEY
                                                                                                    forIndexPath:indexPath];
                    [customCell.ivCustom displayImageWithInfo:imageInfo forSize:((LT_ListOnly == pageView.layoutType) ? IT_Small : IT_Thumb)];

                    cell = customCell;
                }
            }
        }

        if (nil == cell) {
            ImageCollectionViewCell *customCell = [collectionView dequeueReusableCellWithReuseIdentifier:kIMAGE_COLLECTION_VIEW_CELL_KEY
                                                                                            forIndexPath:indexPath];
            [customCell.ivCustom displayImageWithInfo:nil forSize:IT_Loading];
            cell = customCell;
        }
    }

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    if (collectionViewLayout && (YES == [collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]])) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;

        NSInteger itemCount = [collectionView numberOfItemsInSection:section];
        if (1 == itemCount) {
            CGFloat interItemSpacing = [flowLayout minimumInteritemSpacing];
            CGSize itemSize = flowLayout.itemSize;

            CGFloat totalWidth = round(itemCount * itemSize.width + (itemCount - 1) * interItemSpacing);
            CGFloat totalHeight = round(itemCount * itemSize.height + (itemCount - 1) * interItemSpacing);

            CGFloat leftPadding = round(MAX(0.0, ((CGRectGetWidth (collectionView.frame) - totalWidth ) / 2.0)));
            CGFloat topPadding  = round(MAX(0.0, ((CGRectGetHeight(collectionView.frame) - totalHeight) / 2.0)));

            return UIEdgeInsetsMake(topPadding, leftPadding, 0.0, 0.0);
        } else {
            return flowLayout.sectionInset;
        }
    }

    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak ImageOverviewView *pageView = (ImageOverviewView *)self.view;

    if (collectionView == pageView.cvImageOverview) {
        if (indexPath.item < self.imageDataElementsList.count) {
            id imageInfo = [self.imageDataElementsList objectAtIndex:indexPath.item];
            if (imageInfo && (YES == [imageInfo isKindOfClass:[ImageDataModel class]])) {
                [pageView.ivFullImage displayImageWithInfo:imageInfo forSize:IT_Large];

                BOOL animate = (LT_Details == pageView.layoutType);
                [pageView setLayoutType:LT_Details animated:(!animate) completion:^{
                    NSIndexPath *selectedIndex = nil;
                    NSArray *selectedItems = [pageView.cvImageOverview indexPathsForSelectedItems];
                    if (0 != selectedItems.count) {
                        selectedIndex = [selectedItems firstObject];
                    }

                    if (YES == [selectedIndex isEqual:indexPath]) {
                        [pageView.cvImageOverview scrollToItemAtIndexPath:indexPath
                                                         atScrollPosition:(UICollectionViewScrollPositionCenteredVertically | UICollectionViewScrollPositionCenteredHorizontally)
                                                                 animated:YES];
                    } else {
                        [pageView.cvImageOverview selectItemAtIndexPath:indexPath
                                                               animated:animate
                                                         scrollPosition:(UICollectionViewScrollPositionCenteredVertically | UICollectionViewScrollPositionCenteredHorizontally)];
                    }
                }];
            }
        }
    }
}

#pragma mark - CustomImageViewDelegate

- (void)imageTapped:(CustomImageView *)imageView {
    ImageOverviewView *pageView = (ImageOverviewView *)self.view;
    pageView.cvImageOverview.hidden = !pageView.cvImageOverview.hidden;
}

- (void)displayPreviousImage:(CustomImageView *)imageView {
    ImageOverviewView *pageView = (ImageOverviewView *)self.view;

    NSArray *selectedItems = [pageView.cvImageOverview indexPathsForSelectedItems];
    if (0 != selectedItems.count) {
        NSIndexPath *selectedIndex = [selectedItems firstObject];
        if (0 < selectedIndex.item) {
            NSIndexPath *computedIndexPath = [NSIndexPath indexPathForItem:(selectedIndex.item - 1) inSection:selectedIndex.section];
            [self collectionView:pageView.cvImageOverview didSelectItemAtIndexPath:computedIndexPath];
        }
    }
}

- (void)displayNextImage:(CustomImageView *)imageView {
    ImageOverviewView *pageView = (ImageOverviewView *)self.view;

    NSArray *selectedItems = [pageView.cvImageOverview indexPathsForSelectedItems];
    if (0 != selectedItems.count) {
        NSIndexPath *selectedIndex = [selectedItems firstObject];

        NSIndexPath *computedIndexPath = [NSIndexPath indexPathForItem:(selectedIndex.item + 1) inSection:selectedIndex.section];
        [self collectionView:pageView.cvImageOverview didSelectItemAtIndexPath:computedIndexPath];
    }
}

@end
