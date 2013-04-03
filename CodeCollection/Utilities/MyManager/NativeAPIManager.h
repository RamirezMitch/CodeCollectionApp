//
//  NativeAPIManager.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 17/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebRequestObject.h"

@interface NativeAPIManager : NSObject
+ (NativeAPIManager *)defaultManager;
- (NSMutableArray *)arrayAllItems;

#pragma mark web requests
- (NSString*)md5Key;
- (id)webRequest:(WebRequestObject*)webRequestObject;
- (void)webRequestInThread:(WebRequestObject *)webRequestObject;
- (id)requestWithHttpMethod:(NSString*)httpMethod baseURLString:(NSString*)urlString parameters:(NSDictionary *)parameters isMultipart:(BOOL)isMultipart;

@end
