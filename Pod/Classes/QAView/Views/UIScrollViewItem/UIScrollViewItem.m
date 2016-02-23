//
//  UIScrollViewItem.m
//  
//
//  Created by Admin on 19.02.16.
//
//

#import "UIScrollViewItem.h"

@interface UIScrollViewItem () <UIGestureRecognizerDelegate>

@end

@implementation UIScrollViewItem

- (void)setDelegate:(id<UIScrollViewItemDelegate>)delegate
{
    
    self.userInteractionEnabled = YES;
    self.exclusiveTouch = YES;
    
    _delegate = delegate;
    
    static UITapGestureRecognizer* tapRecognizer = nil;
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapRecognizer.cancelsTouchesInView = NO;
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleTapGesture:(UIGestureRecognizer *)sender
{
    [_delegate didRecieveTapInUIScrollViewItemView:self];
}


@end
