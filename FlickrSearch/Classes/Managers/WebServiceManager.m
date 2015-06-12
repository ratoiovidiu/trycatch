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

@property (nonatomic, strong) NSOperationQueue *operationQueue;

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
    self.operationQueue = [[NSOperationQueue alloc] init];
}

- (void)getPhotoListWithTag:(NSString *)text forPageNumber:(NSInteger)pageNumber usingCallback:(void (^)(id response, NSError *error))completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?api_key=%@&method=flickr.photos.search&format=json&text=%@&per_page=10&page=%ld", FSApiKey, text, (long)pageNumber];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    AFHTTPRequestOperation *imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    imageRequestOperation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSDictionary *parsedResponse = nil;

        if (YES == [responseObject isKindOfClass:[NSDictionary class]]) {
            parsedResponse = responseObject;
        } else if (YES == [responseObject isKindOfClass:[NSData class]]) {
            NSData *receivedData = responseObject;

            if (nil == parsedResponse) {
                NSError *jsonError = nil;
                id jsonData = [NSJSONSerialization JSONObjectWithData:receivedData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&jsonError];
                if (YES == [jsonData isKindOfClass:[NSDictionary class]]) {
                    parsedResponse = jsonData;
                } else {
                    error = jsonError;
                }
            }

            if (nil == parsedResponse) {
                NSError *jsonError = nil;
                NSInteger prefixBytes = [@"jsonFlickrApi(" length];
                NSData *subData = [receivedData subdataWithRange:NSMakeRange(prefixBytes, receivedData.length - prefixBytes - 1)];

                id jsonData = [NSJSONSerialization JSONObjectWithData:subData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&jsonError];
                if (YES == [jsonData isKindOfClass:[NSDictionary class]]) {
                    parsedResponse = jsonData;
                } else {
                    error = jsonError;
                }
            }

            if (nil == parsedResponse) {
                NSString *jsonString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
                NSString *trimmedString = [jsonString stringByTrimmingCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"{[]}"] invertedSet]];

                if (0 != trimmedString.length) {
                    NSError *jsonError = nil;
                    id jsonData = [NSJSONSerialization JSONObjectWithData:[trimmedString dataUsingEncoding:NSUTF8StringEncoding]
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:&jsonError];
                    if (YES == [jsonData isKindOfClass:[NSDictionary class]]) {
                        parsedResponse = jsonData;
                    } else {
                        error = jsonError;
                    }
                }
            }
        } else {
            NSString *errorString = @"No data was returned from API";
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorString};
            error = [NSError errorWithDomain:@"api.getPhotoListWithTag.WebServiceManager" code:-1000 userInfo:userInfo];
        }

        if (nil != parsedResponse) {
            NSLog(@"TODO * %@", parsedResponse);
        } else {

        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
    }];
    [self.operationQueue addOperation:imageRequestOperation];
}

@end
