//
//  LocationObjects.h
//  TalkinToTheNet
//
//  Created by Fatima Zenine Villanueva on 9/23/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationObjects : NSObject<MKAnnotation> {
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic) NSString *latitude;
@property (nonatomic) NSString *longitude;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) NSString *weather;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end
