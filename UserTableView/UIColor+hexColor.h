//
//  UIColor+hexColor.h
//  ZJOL
//
//  Created by wujin on 16-12-25.
//

#import <UIKit/UIKit.h>

#define RGB(r,g,b) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1.]

@interface UIColor (hexColor)

+ (UIColor *)hexFloatColor:(NSString *)hexStr;

@end
