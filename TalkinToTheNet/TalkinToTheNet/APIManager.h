//
//  APIManager.h
//  09-19-APILearn
//
//  Created by Fatima Zenine Villanueva on 9/20/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject


+ (void)GETRequestWithURL: (NSURL *)URL
          completeHandler: (void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end
