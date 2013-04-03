//
//  NullRemover.h
//  inSingMovies
//
//  Created by Cellcity-CY on 12/9/10.
//  Copyright 2010 Cellcity Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NullRemover : NSObject {
}
+ (NSString *) safeString:(NSString *)stringValue;
@end
