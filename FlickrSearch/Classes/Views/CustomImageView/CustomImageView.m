//
//  CustomImageView.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 13/06/15.
//
//

#import "CustomImageView.h"

#import "UIImageView+AFNetworking.h"

@interface CustomImageView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation CustomImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentMode = UIViewContentModeCenter;
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
        [self addSubview:_scrollView];

        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:_imageView];

        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _activityIndicator.color = [UIColor blackColor];
        _activityIndicator.layer.cornerRadius = 20.0;
        _activityIndicator.clipsToBounds = YES;
        [self addSubview:_activityIndicator];

        UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
        singleTapRecognizer.delaysTouchesBegan = YES;
        singleTapRecognizer.numberOfTapsRequired = 1;
        singleTapRecognizer.numberOfTouchesRequired = 1;

        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture)];
        doubleTapRecognizer.delaysTouchesBegan = YES;
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.numberOfTouchesRequired = 1;

        [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];

        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove:)];
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;

        [panGestureRecognizer requireGestureRecognizerToFail:_scrollView.panGestureRecognizer];

        [_scrollView addGestureRecognizer:singleTapRecognizer];
        [_scrollView addGestureRecognizer:doubleTapRecognizer];
        [_scrollView addGestureRecognizer:panGestureRecognizer];

        self.zoomEnabled = NO;
    }

    return self;
}

- (void)setZoomEnabled:(BOOL)zoomEnabled {
    _zoomEnabled = zoomEnabled;
    _scrollView.userInteractionEnabled = zoomEnabled;
}

- (void)displayImageWithInfo:(ImageDataModel *)imageInfo forSize:(ImageType)sizeType {
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 1.0;
    _scrollView.zoomScale = 1.0;

    _imageView.image = nil;

    _scrollView.hidden = YES;
    _activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];

    NSURL *url = nil;
    switch (sizeType) {
        case IT_Thumb: {
            url = [NSURL URLWithString:imageInfo.thumbUrlString];
            break;
        }

        case IT_Small: {
            url = [NSURL URLWithString:imageInfo.smallUrlString];
            break;
        }

        case IT_Large: {
            url = [NSURL URLWithString:imageInfo.largeUrlString];
            break;
        }

        default: {
            break;
        }
    }

    if (nil != url) {
        UIImage *smallImage = nil;

        if (!smallImage) {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageInfo.smallUrlString]];
            [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
            smallImage = [[[_imageView class] sharedImageCache] cachedImageForRequest:request];
        }

        if (!smallImage) {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageInfo.thumbUrlString]];
            [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
            smallImage = [[[_imageView class] sharedImageCache] cachedImageForRequest:request];
        }

        if (smallImage) {
            [_activityIndicator stopAnimating];
            _activityIndicator.hidden = YES;
            _scrollView.hidden = NO;

            _imageView.image = smallImage;
            _imageView.frame = self.bounds;
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
        }

        __weak typeof(self) weakSelf = self;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        [_imageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       [weakSelf.activityIndicator stopAnimating];
                                       weakSelf.activityIndicator.hidden = YES;
                                       weakSelf.scrollView.hidden = NO;

                                       weakSelf.imageView.image = image;
                                       weakSelf.imageView.frame = weakSelf.bounds;
                                       weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFit;
                                       [weakSelf resetZoomLevel];
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       [weakSelf.activityIndicator stopAnimating];
                                       weakSelf.activityIndicator.hidden = YES;
                                       weakSelf.scrollView.hidden = NO;

                                       if (nil == weakSelf.imageView.image) {
                                           weakSelf.imageView.image = [UIImage imageNamed:@"broken-link.png"];
                                           weakSelf.imageView.contentMode = UIViewContentModeCenter;
                                           weakSelf.imageView.frame = weakSelf.bounds;
                                           [weakSelf resetZoomLevel];
                                       }
                                   }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.bounds;

    _imageView.frame = frame;
    _scrollView.frame = frame;
    _activityIndicator.frame = frame;

    _scrollView.contentSize = _imageView.bounds.size;
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 1.0;
    _scrollView.zoomScale = 1.0;

    [self resetZoomLevel];
}

- (void)handleTapGesture {
    if (self.delegate && (YES == [self.delegate respondsToSelector:@selector(imageTapped:)])) {
        [self.delegate imageTapped:self];
    }
}

- (void)handleDoubleTapGesture {
    if(_scrollView.zoomScale >= _scrollView.maximumZoomScale){
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    } else {
        [_scrollView setZoomScale:(_scrollView.zoomScale + (_scrollView.maximumZoomScale - _scrollView.minimumZoomScale) / 3.0) animated:YES];
    }

    if (self.delegate && (YES == [self.delegate respondsToSelector:@selector(imageDoubleTapped:)])) {
        [self.delegate imageDoubleTapped:self];
    }
}

- (void)handleMove:(UIPanGestureRecognizer *)recognizer {
    if ((UIGestureRecognizerStateEnded == recognizer.state) && (_scrollView.zoomScale == _scrollView.minimumZoomScale)) {
        CGPoint velocity = [recognizer velocityInView:_scrollView];
        if (velocity.x > 0) {
            if (self.delegate && (YES == [self.delegate respondsToSelector:@selector(displayPreviousImage:)])) {
                [self.delegate displayPreviousImage:self];
            }
        } else {
            if (self.delegate && (YES == [self.delegate respondsToSelector:@selector(displayNextImage:)])) {
                [self.delegate displayNextImage:self];
            }
        }
    }
}

- (void)resetZoomLevel {
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = _imageView.bounds.size;

    CGRect scrollViewFrame = _scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / _scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / _scrollView.contentSize.height;

    CGFloat minScale = MIN(scaleWidth, scaleHeight);

    if (minScale <= 1) {
        _scrollView.contentInset = UIEdgeInsetsZero;

        _scrollView.minimumZoomScale = minScale;
        _scrollView.maximumZoomScale = 4.0;
        _scrollView.zoomScale = minScale;

        CGSize scrollViewSize = _scrollView.bounds.size;
        CGSize scrollViewContentSize = _scrollView.contentSize;

        UIEdgeInsets edgeInset = UIEdgeInsetsZero;
        edgeInset.left = MAX(0.0, round((scrollViewSize.width - scrollViewContentSize.width) / 2.0));
        edgeInset.right = MAX(0.0, round((scrollViewSize.width - scrollViewContentSize.width) / 2.0));
        edgeInset.top = MAX(0.0, round((scrollViewSize.height - scrollViewContentSize.height) / 2.0));
        edgeInset.bottom = MAX(0.0, round((scrollViewSize.height - scrollViewContentSize.height) / 2.0));
        _scrollView.contentInset = edgeInset;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    CGSize scrollViewSize = _scrollView.bounds.size;
    CGSize scrollViewContentSize = _scrollView.contentSize;

    UIEdgeInsets edgeInset = UIEdgeInsetsZero;
    edgeInset.left = MAX(0.0, round((scrollViewSize.width - scrollViewContentSize.width) / 2.0));
    edgeInset.right = MAX(0.0, round((scrollViewSize.width - scrollViewContentSize.width) / 2.0));
    edgeInset.top = MAX(0.0, round((scrollViewSize.height - scrollViewContentSize.height) / 2.0));
    edgeInset.bottom = MAX(0.0, round((scrollViewSize.height - scrollViewContentSize.height) / 2.0));
    _scrollView.contentInset = edgeInset;
}

@end
