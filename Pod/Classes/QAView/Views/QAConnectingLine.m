//
//  QAConnectingLine.m
//  QATrinity
//
//  Created by Admin on 20.02.16.
//  Copyright (c) 2016 PinkStyx. All rights reserved.
//

#import "QAConnectingLine.h"

@implementation QAConnectingLine

-(id)initWithLayer:(CAShapeLayer *)layer
            target:(CGPoint)target
        ctrlPoint1:(CGPoint)ctrlPoint1
        ctrlPoint2:(CGPoint)ctrlPoint2
{
    self = [super init];
    if (self)
    {
        self.lineLayer = layer;
        self.target = target;
        self.ctrlPoint1 = ctrlPoint1;
        self.ctrlPoint2 = ctrlPoint2;
    }
    return self;
}

@end
