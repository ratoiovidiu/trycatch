//
//  WebServiceManager.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 11/06/15.
//
//

#import "WebServiceManager.h"

#import "ImageDataModel.h"
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
    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?api_key=%@&method=flickr.photos.search&format=json&text=%@&per_page=50&page=%ld", FSApiKey, text, (long)pageNumber];

    __weak typeof(self) weakSelf = self;
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

        NSDictionary *processedResponse = nil;
        if (nil != parsedResponse) {
            processedResponse = [weakSelf processFlickrPhotoList:parsedResponse];
            id objError = [processedResponse objectForKey:@"error"];

            if (YES == [objError isKindOfClass:[NSError class]]) {
                processedResponse = nil;
                error = objError;
            } else {
                error = nil;
            }
        }

        if ((nil == processedResponse) && (nil == error)) {
            NSString *errorString = @"Generic API Error";
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorString};
            error = [NSError errorWithDomain:@"api.getPhotoListWithTag.WebServiceManager" code:-1001 userInfo:userInfo];
        }

        if (completionBlock) {
            completionBlock(processedResponse, error);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
    }];
    [self.operationQueue addOperation:imageRequestOperation];
}

#pragma mark - Private Methods

- (NSDictionary *)processFlickrPhotoList:(NSDictionary *)rawResponse {
    if (YES == [rawResponse isKindOfClass:[NSDictionary class]]) {

        NSNumber *currentPage = nil;
        NSNumber *totalPages = nil;
        NSMutableArray *arrPhotoList = [NSMutableArray array];

        id objResponse = [rawResponse objectForKey:@"photos"];
        if (YES == [objResponse isKindOfClass:[NSDictionary class]]) {
            NSDictionary *rawPhotoList = objResponse;
            id objPageNo = [rawPhotoList objectForKey:@"page"];
            if (YES == [objPageNo isKindOfClass:[NSNumber class]]) {
                currentPage = objPageNo;
            }

            id objTotalPages = [rawPhotoList objectForKey:@"pages"];
            if (YES == [objTotalPages isKindOfClass:[NSNumber class]]) {
                totalPages = objTotalPages;
            }

            id objPhotoList = [rawPhotoList objectForKey:@"photo"];
            if (YES == [objPhotoList isKindOfClass:[NSArray class]]) {
                for (id photoDescription in objPhotoList) {
                    [arrPhotoList addObject:[[ImageDataModel alloc] initWithFlickrDescription:photoDescription]];
                }
            }
        }

        if ((0 != arrPhotoList.count) && (nil != currentPage) && (nil != totalPages)) {
            return [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSArray arrayWithArray:arrPhotoList], @"arrPhotoList",
                    currentPage, @"currentPage",
                    totalPages, @"totalPages",
                    nil];
        }
    }

    // RETURN ERROR IF EXECUTION REACHES HERE
    NSString *errorString = @"Failed to parse received data";
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorString};
    NSError *error = [NSError errorWithDomain:@"api.getPhotoListWithTag.WebServiceManager" code:-1002 userInfo:userInfo];

    return [NSDictionary dictionaryWithObjectsAndKeys:
            error, @"error",
            nil];
}

@end
