//
//  WebRequestObject.m
//  STMobileV3
//
//  Created by honcheng on 1/12/10.
//  Copyright 2010 databinge. All rights reserved.
//

#import "WebRequestObject.h"


@implementation WebRequestObject
@synthesize httpMethod, parameters, urlString, notificationName, synchronous;
@synthesize isMultipart;

- (NSString*)description
{
	NSMutableString *description = [NSMutableString stringWithString:@""];
	[description appendFormat:@"http method: %@", httpMethod];
	[description appendFormat:@"\nURL: %@", urlString];
	[description appendFormat:@"\nnotification name: %@", notificationName];
	[description appendFormat:@"\nsynchronous: %i", synchronous];
	[description appendFormat:@"\nparameters: %@", parameters];
	return description;
}

@end
