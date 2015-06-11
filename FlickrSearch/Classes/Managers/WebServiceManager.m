//
//  WebServiceManager.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 11/06/15.
//
//

#import "WebServiceManager.h"

#import "ConstantsGeneral.h"
#import <AFNetworking/AFNetworking.h>

@interface WebServiceManager()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation WebServiceManager

+ (WebServiceManager *)shared {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // OR SOME OTHER INIT METHOD
        [_sharedObject initialConfiguration];
    });
    return _sharedObject;
}

- (void)initialConfiguration {
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];

    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript", nil];

    //[self.sessionManager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    //
    //[self.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[self.sessionManager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    //
    //NSMutableSet *currentContentTypes = [NSMutableSet setWithSet:self.sessionManager.responseSerializer.acceptableContentTypes];
    //[currentContentTypes addObject:@"text/html"];
    //[currentContentTypes addObject:@"text/plain"];
    //self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithSet:currentContentTypes];
}

- (void)getPhotoListWithTag:(NSString *)text forPageNumber:(NSInteger)pageNumber usingCallback:(void (^)(id response, NSError *error))callback {
    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?api_key=%@&method=flickr.photos.search&format=json&text=%@&per_page=10&page=%ld", FSApiKey, text, (long)pageNumber];

    [self.sessionManager GET:urlString
                  parameters:nil
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         NSLog(@"TODO *");
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         NSLog(@"TODO *");
                     }];
}

@end
