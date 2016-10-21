//
//  QLProfileAddCardCell.m
//  QLoan
//
//  Created by Nikulin Maksim on 21/10/16.
//  Copyright © 2016 Rambler&Co. All rights reserved.
//

#import "QLProfileAddCardCell.h"

#import "QLProfileAddCardCellObject.h"

static CGFloat const QLProfileAddCardCellHeight = 44.0;

@implementation QLProfileAddCardCell

- (BOOL)shouldUpdateCellWithObject:(QLProfileAddCardCellObject *)object {
    return YES;
}

+ (CGFloat)heightForObject:(id)object
               atIndexPath:(NSIndexPath *)indexPath
                 tableView:(UITableView *)tableView {
    return QLProfileAddCardCellHeight;
}

@end
