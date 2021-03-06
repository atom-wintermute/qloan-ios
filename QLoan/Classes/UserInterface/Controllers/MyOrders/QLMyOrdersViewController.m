//
//  QLMyOrdersViewController.m
//  QLoan
//
//  Created by Nikulin Maksim on 21/10/16.
//  Copyright © 2016 Rambler&Co. All rights reserved.
//

#import "QLMyOrdersViewController.h"

#import "QLMyOrdersCellFactory.h"
#import "QLPersonalCabinetService.h"
#import "QLMyOrdersDataDisplayManager.h"
#import "QLMyOrdersOrderCellObject.h"
#import "QLOrderDetailViewController.h"
#import "ServicesConstants.h"
#import "QLBorrowerOrder.h"
#import "QLOrderInfo.h"
#import "QLMyOrdersEmptyDataView.h"
#import "ALView+PureLayout.h"
#import "QLAppRouterImplementation.h"

#import "QLUserInfoService.h"

static NSInteger const QLAllSelectedSegment = 0;
static NSInteger const QLBorrowersSelectedSegment = 1;
static NSInteger const QLLendersSelectedSegment = 2;

@interface QLMyOrdersViewController () <UITableViewDelegate>

@property (nonatomic, strong) QLMyOrdersDataDisplayManager *dataDisplayManager;
@property (nonatomic, strong) NSArray *myBorrowerOrderInfos;
@property (nonatomic, strong) NSArray *myLenderOrderInfos;
@property (nonatomic, assign) NSInteger currentSegmentSelected;

@end

@implementation QLMyOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Мои заявки";
	
}

- (IBAction)segmentChanged:(id)sender {
	[self showData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  //  [self showData];
	[self loadData];
	
//	[self.router openViewControllerWithNotification:@{ @"note_id" : @"5", @"type" : @"loan_receipt_requested" }];
}

#pragma mark - Приватные методы

- (void)showData {
	NSMutableArray *cellObjects = [NSMutableArray new];
	switch (self.segmentedControl.selectedSegmentIndex) {
		case QLAllSelectedSegment:
			
			cellObjects = self.myLenderOrderInfos == nil ?
			[NSMutableArray new] : [[self.cellFactory cellObjectsFromMyLenderOrders:self.myLenderOrderInfos] mutableCopy];
			if (self.myBorrowerOrderInfos != nil) [cellObjects addObjectsFromArray:[self.cellFactory cellObjectsFromMyBorrowerOrders:self.myBorrowerOrderInfos]];
			
			break;
		case QLLendersSelectedSegment:
			cellObjects = self.myLenderOrderInfos == nil ?
			[NSMutableArray new] : [[self.cellFactory cellObjectsFromMyLenderOrders:self.myLenderOrderInfos] mutableCopy];
			break;
		case QLBorrowersSelectedSegment:
			if (self.myBorrowerOrderInfos != nil) [cellObjects addObjectsFromArray:[self.cellFactory cellObjectsFromMyBorrowerOrders:self.myBorrowerOrderInfos]];
			break;
	}
	
    self.dataDisplayManager =  [[QLMyOrdersDataDisplayManager alloc] initWithInputData:cellObjects
                                                       andConversionToCellObjectsBlock:^id(id dataObject) {
                                                           return dataObject;
                                                       }];
    
        self.tableView.dataSource = [self.dataDisplayManager dataSourceForTableView:self.tableView];
        self.tableView.delegate = [self.dataDisplayManager delegateForTableView:self.tableView
                                                               withBaseDelegate:self];
    [self.tableView reloadData];
}

- (void)loadData {
	__block NSMutableArray *idsArray = [NSMutableArray new];
	
	QLUserInfosCompletionBlock userInfoCompletion = ^(NSArray *infos, NSError *error) {
		if (error) {
			return;
		} else if (!infos) {
			[self showData];
			return;
		}
		
		for (QLOrderInfo *orderInfo in self.myBorrowerOrderInfos) {
			for (QLUserInfo *user in infos) {
				if (orderInfo.order.lenderId == user.userId) {
					orderInfo.user = user;
					continue;
				}
			}
		}
		
		for (QLOrderInfo *orderInfo in self.myLenderOrderInfos) {
			for (QLUserInfo *user in infos) {
				if (orderInfo.order.borrowerId == user.userId) {
					orderInfo.user = user;
					continue;
				}
			}
		}
		[self showData];
	};
	
	QLBorrowersOrderCompletion lenderCompletion = ^(NSArray *orders, NSError *error) {
		if (error == nil) {
	
			NSMutableArray *lendersInfoArray = [NSMutableArray new];
			
			for (QLBorrowerOrder *order in orders) {
				QLOrderInfo *info = [QLOrderInfo new];
				info.order = order;
				[lendersInfoArray addObject:info];
				
				if (order.borrowerId != 0 && ![idsArray containsObject:@(order.borrowerId)]) {
					[idsArray addObject:@(order.borrowerId)];
				}
			}
			
			self.myLenderOrderInfos = [lendersInfoArray copy];
			
			if (idsArray.count > 0) {
				[self.userInfoService infoForUserWithIds:[idsArray copy]
											  completion:userInfoCompletion];
			} else {
				userInfoCompletion(nil, nil);
			}
		}
	};
	
	QLBorrowersOrderCompletion borrowerCompletion = ^(NSArray *orders, NSError *error) {
		if (error == nil) {
			
			NSMutableArray *borrowersInfoArray = [NSMutableArray new];
			
			for (QLBorrowerOrder *order in orders) {
				QLOrderInfo *info = [QLOrderInfo new];
				info.order = order;
				[borrowersInfoArray addObject:info];
				
				if (order.lenderId != 0 &&![idsArray containsObject:@(order.lenderId)]) {
					[idsArray addObject:@(order.lenderId)];
				}
			}
			self.myBorrowerOrderInfos = [borrowersInfoArray copy];
			
			[self.personalCabinetService myLenderOrdersWithPage:0
													 sortMethod:QLSortByRating
													  ascending:YES
													 completion:lenderCompletion];
		}
	};
	
	[self.personalCabinetService myBorrowerOrdersWithPage:0
											   sortMethod:QLSortByRating
												ascending:YES
											   completion:borrowerCompletion];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	QLMyOrdersOrderCellObject *object = [self.dataDisplayManager objectAtIndexPath:indexPath];
	if (object != nil) {
		QLOrderInfo *orderInfo = object.orderInfo;
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Get"
															 bundle:[NSBundle mainBundle]];
		QLOrderDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"QLOrderDetailViewController"];
		if (controller != nil) {
			controller.orderInfo = orderInfo;
			[self.navigationController pushViewController:controller
												 animated:YES];
		}
	}
}

@end
