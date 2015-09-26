//
//  SearchVC.h
//  TalkinToTheNet
//
//  Created by Fatima Zenine Villanueva on 9/25/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchFieldDelegate.h"

@interface SearchVC : UIViewController

@property (nonatomic, weak) id <SearchFieldDelegate> delegate;


@end
