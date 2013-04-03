//
//  Product.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 18/3/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
@property (nonatomic, retain) NSString * product_code;
@property (nonatomic, retain) NSString * product_title;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber *segmentCode;
@property (nonatomic, retain) NSString * segmentDesc;
@property (nonatomic, retain) NSString * imageUrlSmall;
@property (nonatomic, retain) NSString * characterGroup;
- (id) initWithDictionary:(NSDictionary *)dict;

@end
