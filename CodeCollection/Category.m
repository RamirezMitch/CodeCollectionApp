//
//  Category.m
//  gpt
//
//  Created by Michelle Ramirez on 29/8/12.
//  Copyright (c) 2012 tanto@thecellcity.com. All rights reserved.
//

#import "Category.h"
#import "MyUtil.h"

@implementation Category
@synthesize catId;
@synthesize catname;
@synthesize cattype;
@synthesize isSelected;

- (id) initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.catId = [MyUtil safeString:[dict objectForKey:@"ID"]];
        self.catname = [MyUtil safeString:[dict objectForKey:@"Name"]];
        self.cattype = [MyUtil safeString:[dict objectForKey:@"Type"]];
        self.isSelected = NO;
            }
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"Cat:%@",catname];
}

/*
- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToCategory:other];
}

- (BOOL)isEqualToCategory:(Category *)aCat {
    if (self == aCat) {
        return YES;
    }
    if (! [[aCat.catId lowercaseString] isEqualToString:[self.catId lowerCaseString]] ) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash
{
    return (NSUInteger)self;
}
*/

- (void) dealloc {
    [catId release];
    [catname release];
    [cattype release];
    [super dealloc];
}


@end
