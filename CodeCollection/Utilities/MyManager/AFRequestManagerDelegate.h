//
//  AFRequestManagerDelegate.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 14/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class AFRequestManager;
@protocol AFRequestManagerDelegate

- (void) afrequestManager:(AFRequestManager *)sh didGetResults:(NSDictionary *)resultsIn withError:(NSString *)errorIn ofQuery:(QueryType)qType;
@end

