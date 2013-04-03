//
//  NullRemover.m
//
//  Created by Cellcity-CY on 12/9/10.
//  Copyright 2010 Cellcity Ltd. All rights reserved.
//

#import "NullRemover.h"


@implementation NullRemover

+(NSString *)safeString:(NSString *)stringValue
{
	if (stringValue==nil)
		return @"";
	else if ([stringValue isEqual:[NSNull null]])
		return @"";
    else if (stringValue == (id)[NSNull null]) 
        return @"";
	return stringValue;
}
@end
