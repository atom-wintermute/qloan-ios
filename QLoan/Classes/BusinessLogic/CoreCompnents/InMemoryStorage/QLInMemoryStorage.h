//
//  QLInMemoryStorage.h
//  QLoan
//
//  Created by Nikulin Maksim on 21/10/16.
//  Copyright © 2016 Rambler&Co. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QLStorage.h"

@interface QLInMemoryStorage : NSObject <QLStorage>

@property (nonatomic, strong) NSDictionary *storageDictionary;

@end
