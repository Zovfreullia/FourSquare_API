//
//  SearchFieldDelegate.h
//  TalkinToTheNet
//
//  Created by Fatima Zenine Villanueva on 9/25/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchFieldDelegate <NSObject>

@required

- (void)userHitsGoSearchButton:(NSString *)searchItem;


@end
