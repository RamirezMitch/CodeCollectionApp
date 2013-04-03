/*
 *  JSONDataReaderDelegate.h
 *  DBSShopper
 *
 *  Created by Cellcity-CY on 8/31/10.
 *  Copyright 2010 Cellcity Ltd. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
@class JSONDataReader;

@protocol JSONDataReaderDelegate 
-(void)dataLoaded:(JSONDataReader *)dataReader;
-(void)dataLoadedWithError:(JSONDataReader *)dataReader;
@end