//
//  GridCell.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 29/4/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"

@interface GridCell : UIGridViewCell {
    
}

@property (nonatomic, retain) IBOutlet UIImageView *thumbnail;
@property (nonatomic, retain) IBOutlet UILabel *label;

@end
