//
//  CustomImageView.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 13/06/15.
//
//

#import "CustomImageView.h"

#import "UIImageView+AFNetworking.h"

@interface CustomImageView ()

@property (nonatomic, strong) UIImageView *ivPhoto;
@property (nonatomic, strong) UIActivityIndicatorView *aivLoading;

@end

@implementation CustomImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _ivPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
        _ivPhoto.contentMode = UIViewContentModeScaleAspectFit;
        _ivPhoto.backgroundColor = [UIColor clearColor];
        [self addSubview:_ivPhoto];

        _aivLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _aivLoading.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _aivLoading.color = [UIColor blackColor];
        [self addSubview:_aivLoading];
    }

    return self;
}

- (void)displayImageWithInfo:(ImageDataModel *)imageInfo forSize:(ImageType)sizeType {
    self.ivPhoto.hidden = YES;
    self.aivLoading.hidden = NO;
    [self.aivLoading startAnimating];

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

        if (IT_Large == sizeType) {
            if (nil == smallImage) {
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageInfo.smallUrlString]];
                [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
                smallImage = [[[self.ivPhoto class] sharedImageCache] cachedImageForRequest:request];
            }

            if (nil == smallImage) {
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageInfo.thumbUrlString]];
                [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
                smallImage = [[[self.ivPhoto class] sharedImageCache] cachedImageForRequest:request];
            }
        }

        if (smallImage) {
            self.ivPhoto.hidden = NO;
            self.ivPhoto.image = smallImage;

            self.aivLoading.hidden = YES;
            [self.aivLoading stopAnimating];
        }

        __weak typeof(self) weakSelf = self;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        [self.ivPhoto setImageWithURLRequest:request
                            placeholderImage:nil
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                         weakSelf.ivPhoto.hidden = NO;
                                         weakSelf.ivPhoto.image = image;

                                         weakSelf.aivLoading.hidden = YES;
                                         [weakSelf.aivLoading stopAnimating];
                                     }
                                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                         weakSelf.aivLoading.hidden = YES;
                                         [weakSelf.aivLoading stopAnimating];
                                     }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _ivPhoto.frame = self.bounds;
    _aivLoading.frame = self.bounds;
}

@end
