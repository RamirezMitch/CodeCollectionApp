//
//  WebRequestObject.h
//  STMobileV3
//
//  Created by honcheng on 1/12/10.
//  Copyright 2010 databinge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebRequestObject : NSObject {
	NSString *httpMethod;
	NSMutableDictionary *parameters;
	NSString *urlString;
	NSString *notificationName;
	BOOL	synchronous;
	BOOL	isMultipart;
	
}

@property (nonatomic, retain) NSString *httpMethod;
@property (nonatomic, retain) NSMutableDictionary *parameters;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *notificationName;
@property (nonatomic, assign) BOOL synchronous;
@property (nonatomic, assign) BOOL isMultipart;

- (NSString*)description;

@end
