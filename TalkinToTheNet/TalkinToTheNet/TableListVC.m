//
//  TableListVC.m
//  TalkinToTheNet
//
//  Created by Fatima Zenine Villanueva on 9/25/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "TableListVC.h"
#import "LocationObjects.h"
#import "APIManager.h"

@interface TableListVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TableListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSLog(@"%@", self.locationResults);
    
    
    for (int i = 0; i < self.locationResults.count; i++) {
        LocationObjects *obj = [self.locationResults objectAtIndex:i];
        [self makeNewWeatherRequestWithSearchTerm:obj callbackBlock:^{
            [self.tableView reloadData];
        }];
    }
}


- (IBAction)closeButton:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    LocationObjects *post = self.locationResults[indexPath.row];
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Weather: %@", post.weather];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationResults.count;
}

#pragma mark - Weather

- (void)makeNewWeatherRequestWithSearchTerm: (LocationObjects *)obj
                              callbackBlock:(void(^)())block {
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@",obj.latitude, obj.longitude];
    
    NSString *encodedstring = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"%@", encodedstring);
    
    NSURL *url = [NSURL URLWithString:encodedstring];
    
    [APIManager GETRequestWithURL:url completeHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data !=nil){
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSDictionary *weather = [json objectForKey:@"weather"];
            
            for (NSDictionary *result in weather) {
                NSString *detailWeather = [result objectForKey:@"description"];
                obj.weather = detailWeather;
            }
            block();
        }
        
    }];
    
}



@end
