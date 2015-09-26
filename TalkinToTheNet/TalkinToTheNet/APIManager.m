//
//  APIManager.m
//  09-19-APILearn
//
//  Created by Fatima Zenine Villanueva on 9/20/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager

+ (void)GETRequestWithURL: (NSURL *)URL
          completeHandler: (void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    
    // creating the request
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //NSLog(@"%@", data);
            
            completionHandler(data, response, error);
            
        });
    }];
    
    [task resume];
}

@end
