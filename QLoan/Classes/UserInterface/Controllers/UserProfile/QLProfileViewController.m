//
//  QLProfileViewController.m
//  QLoan
//
//  Created by Nikulin Maksim on 20/10/16.
//  Copyright © 2016 Rambler&Co. All rights reserved.
//

#import "QLProfileViewController.h"

#import "QLBankAuthService.h"
#import "QLBankCardService.h"
#import "QLProfileCellFactory.h"

#import "QLProfileDataDisplayManager.h"

#import "QLBankUserInfo.h"

@interface QLProfileViewController () <UITableViewDelegate>

@property (nonatomic, strong) QLProfileDataDisplayManager *dataDisplayManager;

@end

@implementation QLProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

#pragma mark - Приватные методы

- (void)configureView {
    [self.view layoutIfNeeded];
    [self.headerView addGradient];
    
    QLBankUserInfo *bankUserInfo = [self.bankAuthService obtainCurrentUserData];
    if (!bankUserInfo) {
        return;
    }
    
    self.usernameLabel.text = [NSString stringWithFormat:@"%@ %@", bankUserInfo.firstName, bankUserInfo.lastName];
    
    NSArray <QLBankCard *> *cardList = [self.bankCardService obtainBankCards];
    NSArray *cellObjects = [self.cellFactory cellObjectsFrom:bankUserInfo
                                                    cardList:cardList];
    self.dataDisplayManager =  [[QLProfileDataDisplayManager alloc] initWithInputData:cellObjects
                                                      andConversionToCellObjectsBlock:^id(id dataObject) {
                                                          return dataObject;
                                                      }];
    
    self.tableView.dataSource = [self.dataDisplayManager dataSourceForTableView:self.tableView];
    self.tableView.delegate = [self.dataDisplayManager delegateForTableView:self.tableView
                                                           withBaseDelegate:self];
    [self.tableView reloadData];
}

@end