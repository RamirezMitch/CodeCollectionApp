//
//  Category.h
//  gpt
//
//  Created by Michelle Ramirez on 29/8/12.
//  Copyright (c) 2012 tanto@thecellcity.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject
@property (nonatomic, retain) NSString * catId;
@property (nonatomic, retain) NSString * catname;
@property (nonatomic, retain) NSString * cattype;
@property (nonatomic, assign) BOOL isSelected; // For selecting category

- (id) initWithDictionary:(NSDictionary *)dict;
@end
