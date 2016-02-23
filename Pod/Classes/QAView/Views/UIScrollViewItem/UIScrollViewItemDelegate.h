//
//  UIScrollViewItemDelegate.h
//  QATrinity
//
//  Created by Admin on 19.02.16.
//  Copyright (c) 2016 PinkStyx. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIScrollViewItem;

@protocol UIScrollViewItemDelegate <NSObject>
@required

- (void)didRecieveTapInUIScrollViewItemView:(UIScrollViewItem *)itemView;

@end
