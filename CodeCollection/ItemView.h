//
//  ItemView.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 22/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DItem.h"
#import "Product.h"
@class ItemView;
@interface ItemView : UIView{
UIImageView* mainImage;
UILabel* title;
UIImageView* arrowImage;
UIView* offerSheet;
UILabel* offerLabel;
NSDictionary* itemData;


}
@property(nonatomic,retain) UIImageView* mainImage;
@property(nonatomic,retain) UILabel* title;
@property(nonatomic,retain) UIImageView* arrowImage;
@property(nonatomic,retain) UIButton* clearButton;
@property(nonatomic,retain) UIView* offerSheet;
@property(nonatomic,retain) UILabel* offerLabel;
@property(nonatomic,retain) NSDictionary* itemData;


@property (nonatomic,retain) Product *deal;

- (void)applyItemData:(NSDictionary*)data;
- (void)applyDealsData:(Product*)deal;
- (void)clearItemData;

@end
