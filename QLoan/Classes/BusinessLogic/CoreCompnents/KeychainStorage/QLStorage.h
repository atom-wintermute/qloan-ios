//
//  QLStorage.h
//  QLoan
//
//  Created by Nikulin Maksim on 20/10/16.
//  Copyright © 2016 Rambler&Co. All rights reserved.
//

#import "QLSessionCredentials.h"
#import "QLAuthorizationRequestConfiguration.h"

/**
 Протокол хранилища
 */
@protocol QLStorage <NSObject>

/**
 Запись объекта в хранилище по ключу

 @param object объект
 @param key    ключ
 */
- (void)storeObject:(id)object
             forKey:(NSString *)key;

/**
 Загрузка объекта по ключу

 @param key ключ

 @return объект
 */
- (id)loadObjectForKey:(NSString *)key;

/**
 Удаление объекта по ключу

 @param key ключ
 */
- (void)removeObjectForKey:(NSString *)key;

- (QLSessionCredentials *)credentialsForCurrentUser;

- (void)setCredentialsForCurrentUser:(QLSessionCredentials *)credentials;

- (QLAuthorizationRequestConfiguration *)authorizationConfigurationForCurrentUser;

- (void)setAuthorizationConfiguration:(QLAuthorizationRequestConfiguration *)configuration;

@end
