//
//  UIScrollViewItem.h
//  
//
//  Created by Admin on 19.02.16.
//
//

#import <UIKit/UIKit.h>
#import "UIScrollViewItemDelegate.h"

@interface UIScrollViewItem : UIView

@property (nonatomic, weak) id<UIScrollViewItemDelegate>delegate;

@end
