//
//  ImageToDrag.h
//
//  Created by John on 1/11/11.
//  Copyright iOSDeveloperTips.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
@interface ImageToDrag : UIImageView <UIGestureRecognizerDelegate>{
    
    CGFloat _lastScale;
	CGFloat _lastRotation;
	CGFloat _firstX;
	CGFloat _firstY;
    
   
    CAShapeLayer *_marque;

	CGPoint currentPoint;
    UIView *canvasView;
}
@property (nonatomic,retain) UIView *canvasView;

@end
