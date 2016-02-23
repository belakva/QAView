//
//  QAConnectingLine.h
//  QATrinity
//
//  Created by Admin on 20.02.16.
//  Copyright (c) 2016 PinkStyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAConnectingLine : NSObject

@property (strong, nonatomic) CAShapeLayer* lineLayer;
@property (nonatomic) CGPoint target;
@property (nonatomic) CGPoint ctrlPoint1;
@property (nonatomic) CGPoint ctrlPoint2;

-(id)initWithLayer:(CAShapeLayer *)layer
            target:(CGPoint)target
        ctrlPoint1:(CGPoint)ctrlPoint1
        ctrlPoint2:(CGPoint)ctrlPoint2;

@end
