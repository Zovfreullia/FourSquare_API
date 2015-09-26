//
//  ListOfPlacesVC.m
//  TalkinToTheNet
//
//  Created by Fatima Zenine Villanueva on 9/22/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "ListOfPlacesVC.h"
#import "APIManager.h"
#import "LocationObjects.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "SearchVC.h"
#import "TableListVC.h"

@interface ListOfPlacesVC () <MKMapViewDelegate, CLLocationManagerDelegate, SearchFieldDelegate>



@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *yourMapView;
@property (nonatomic) NSMutableArray *searchResults;
@property (nonatomic) NSString *latitude;
@property (nonatomic) NSString *longitude;

@end

@implementation ListOfPlacesVC

#pragma mark - Delegate

- (void)userHitsGoSearchButton:(NSString *)searchItem{
    [self.yourMapView removeAnnotations:self.yourMapView.annotations];
    NSLog(@"Delegate working: %@", searchItem);
    [self makeNewFourSquareRequestWithSearchTerm:searchItem callbackBlock:^{
        [self.tableView reloadData];
    }];
}

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];

    self.yourMapView.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Map View

- (IBAction)getLocation:(UIBarButtonItem *)sender {
    self.yourMapView.showsUserLocation = YES;
}


#pragma mark - FourSquare Request

- (void)makeNewFourSquareRequestWithSearchTerm: (NSString *)searchTerm
                             callbackBlock:(void(^)())block {
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=5Y2D3ZEAIKSIXM1ENLUST5SUWU00KZ1PWONSWEPM4VL4MPWY&client_secret=UTBSHJFUEMDSVGLBTOQG4PSP00ZHGIIUUIZJVWHG4Y3O3XK0&v=20130815&ll=%@,%@&query=%@",self.latitude,self.longitude, searchTerm];
    
    NSString *encodedstring = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"%@", encodedstring);
    
    NSURL *url = [NSURL URLWithString:encodedstring];
    
    [APIManager GETRequestWithURL:url completeHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data !=nil){
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSDictionary *response = [json objectForKey:@"response"];
            NSDictionary *venues = [response objectForKey:@"venues"];
   
            self.searchResults = [[NSMutableArray alloc]init];
            
            for (NSDictionary *result in venues){
                
                NSString *lngString = [[result objectForKey:@"location"] objectForKey:@"lng"];
                NSString *latString =  [[result objectForKey:@"location"] objectForKey:@"lat"];
                double lat = [latString doubleValue];
                double lng = [lngString doubleValue];
                
                NSString *name = [result objectForKey:@"name"];
                NSString *address = [[result objectForKey:@"location"]objectForKey:@"address"];
                
                MKCoordinateRegion region = { {0.0, 0.0} , {0.0, 0.0} };
                region.center.latitude = lat;
                region.center.longitude = lng;
                region.span.longitudeDelta = 0.01f;
                region.span.latitudeDelta = 0.01f;
                
                [self.yourMapView setRegion:region animated:YES];
                
                LocationObjects *obj = [[LocationObjects alloc]init];
                obj.title = name;
                obj.subtitle = address;
                obj.latitude = self.latitude;
                obj.longitude = self.longitude;
                obj.coordinate = region.center;
                
                [self.yourMapView addAnnotation:obj];
                
                [self.searchResults addObject:obj];
                
            }
            
            block();
        }
        
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = locations.lastObject;
    self.longitude = [NSString stringWithFormat:@"%.1f", location.coordinate.longitude];
    self.latitude = [NSString stringWithFormat:@"%.1f",location.coordinate.latitude];
    NSLog(@"latitude: %@ and longitude: %@", self.latitude, self.longitude);
    
    [self.locationManager stopUpdatingLocation];
}


#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"TableViewID"]){
        NSLog(@"Off to the table!");
        TableListVC *vc = segue.destinationViewController;
        vc.locationResults = self.searchResults;
    }
    
    else if ([[segue identifier] isEqualToString:@"SearchViewID"]){
        SearchVC *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

@end
