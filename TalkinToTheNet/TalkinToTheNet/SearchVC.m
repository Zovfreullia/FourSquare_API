//
//  SearchVC.m
//  TalkinToTheNet
//
//  Created by Fatima Zenine Villanueva on 9/25/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "SearchVC.h"

@interface SearchVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchField;

@end

@implementation SearchVC

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // dismiss the keyboard
    [self.view endEditing:YES];
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.searchField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeScreen:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)goSearchButton:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.delegate userHitsGoSearchButton:self.searchField.text];
}



@end
