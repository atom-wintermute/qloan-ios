//
//  QLProfileCardCellObject.h
//  QLoan
//
//  Created by Nikulin Maksim on 21/10/16.
//  Copyright © 2016 Rambler&Co. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Nimbus/NimbusModels.h>

@interface QLProfileCardCellObject : NSObject <NICellObject, NINibCellObject>

@property (nonatomic, strong) NSString *cardNameString;
@property (nonatomic, strong) NSString *balanceString;

@end
