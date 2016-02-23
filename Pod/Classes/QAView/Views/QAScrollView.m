//
//  QAScrollView.m
//  QATrinity
//
//  Created by Admin on 19.02.16.
//  Copyright (c) 2016 PinkStyx. All rights reserved.
//

#import "QAScrollView.h"

@interface QAScrollView () <UIGestureRecognizerDelegate>

@end

@implementation QAScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    {
        static UITapGestureRecognizer* tapRecognizer = nil;
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapRecognizer.cancelsTouchesInView = NO;
        tapRecognizer.delegate = self;
        [self addGestureRecognizer:tapRecognizer];
        
        _oldOffsetY = 0.;
    }
    return self;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleTapGesture:(UIGestureRecognizer *)sender
{
    self.canCancelContentTouches = NO;
}



@end
