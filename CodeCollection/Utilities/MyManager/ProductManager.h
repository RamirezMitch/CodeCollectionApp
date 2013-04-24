//
//  ProductManager.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 5/4/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProductManagerDelegate;

@interface ProductManager : NSObject <UIWebViewDelegate> {
    NSString *xlsContent;
    NSArray *arrRowBundle;
    NSMutableArray *listBundlePrd;
    id<ProductManagerDelegate> delegate;
    BOOL *groupAll;
}
@property (nonatomic, retain) NSMutableDictionary *listSection;
@property (nonatomic, retain) NSArray *listContent;
@property(nonatomic,assign) id<ProductManagerDelegate> delegate;
-(id)initWithDelegate:(id)del :(BOOL)grouped;
- (void) cancelRequest;
- (void)loadXLS;
-(NSString*)getXLSField:(int)row:(int)col;
@end

@protocol ProductManagerDelegate <NSObject>
@optional
- (void)dProductManager:(ProductManager *)om shouldShowAllItems:(NSArray *)allItems;
- (void)dProductManager:(ProductManager *)om shouldShowAllSections:(NSMutableDictionary *)allSections;

@end
