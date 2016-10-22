//
//  QLAddCardViewController.m
//  QLoan
//
//  Created by Nikulin Maksim on 22/10/16.
//  Copyright © 2016 Rambler&Co. All rights reserved.
//

#import "QLAddCardViewController.h"

#import "QLBankCardService.h"

@interface QLAddCardViewController ()

@end

@implementation QLAddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view layoutIfNeeded];
    [self configureAppearance];
}

#pragma mark - Приватные методы

- (void)configureAppearance {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    self.navigationItem.title = @"Добавить карту";
}

@end
