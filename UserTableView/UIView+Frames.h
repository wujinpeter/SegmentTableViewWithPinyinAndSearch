//
//  UILabel+Frame.h
//  CCBClientV2
//
//  Created by wujin on 16-12-25.
//

#import <UIKit/UIKit.h>

@interface UIView (Frames)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign, readonly) CGFloat bottomY;
@property (nonatomic, assign, readonly) CGFloat rightX;
@end
