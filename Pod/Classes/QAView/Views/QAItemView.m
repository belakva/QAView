//
//  QAItemView.m
//  QATrinity
//
//  Created by Admin on 18.02.16.
//  Copyright (c) 2016 PinkStyx. All rights reserved.
//

#import "QAItemView.h"
#import "QAConnectingLine.h"

static CGFloat const kQAConnectingLineWidth = 3.;
static CGFloat const kQAConnectingAnimationDuration = 0.2;

static CGFloat const kQAInactiveColorBrightness = 0.89;
static CGFloat const kQAActiveColorSaturation = 0.45;
CGFloat const kItemToParentScrollViewWidthFactor = 0.8;                         //is extern
static CGFloat const kTriangleWidthFactor = 0.5;                                // width in terms of view, in geometric terms - height

@interface QAItemView ()

@property (strong, nonatomic) CAShapeLayer* gradientMaskLayer;
@property (strong, nonatomic) CAGradientLayer* gradientLayer;

@end

@implementation QAItemView
{
    UIColor* _annotationColor; // color, taken for drawing. Can be equal to inactive or to highlight color
    
    CAShapeLayer* _colorLayer;
    CAShapeLayer* _circleLayer;
    
    UIView* _colorView;
    
    CGFloat _triangleWidth;
    
    NSMutableDictionary* _colorsOfConnectedQuestions;
    NSMutableDictionary* _lines;
    
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame text:(NSString*)text
                                 index:(NSInteger)index
                        totalQuestions:(NSInteger)totalQuestions
                         inactiveColor:(UIColor*)inactiveColor
                           activeColor:(UIColor*)activeColor
                            asQuestion:(BOOL)asQuestion
{
    self = [super initWithFrame: frame];
    if (self)
    {
        _index = index;
        _isQuestion = asQuestion;
        
        [self commonInit];
        
        _highlightColor = activeColor;
        _inactiveColor = inactiveColor;
        _textLabel.text = text;
        
        [self setUpWithIndex:index ofTotalQuestions:totalQuestions];
       
    }
    return self;
}

- (void)commonInit
{
    self.clipsToBounds = NO;
    _useCurvesInConnection = YES;
    _useCirclesOnLineConnectionPoints = YES;
    _useGradients = YES;
    _connectingLineWidth = kQAConnectingLineWidth;
    _connectingAnimationDuration = kQAConnectingAnimationDuration;
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    _textLabel.textColor = [UIColor darkGrayColor];
    _textLabel.numberOfLines = 0;
    _textLabel.font = [UIFont systemFontOfSize:17];
    
    _colorView = [[UIView alloc] init];
    [self addSubview:_colorView];
}

- (void)setUpWithIndex:(NSUInteger)index ofTotalQuestions:(NSUInteger)totalQuestions
{
    _colorView.frame = self.bounds;
    
    _colorLayer = [[CAShapeLayer alloc] init];
    _colorLayer.contentsGravity = kCAGravityResizeAspect;
    _colorLayer.bounds = self.bounds;
    
    _annotationColor = _inactiveColor != nil ? _inactiveColor : [UIColor colorWithHue:0 saturation:0 brightness:kQAInactiveColorBrightness alpha:1];
    _colorLayer.fillColor = _annotationColor.CGColor;
    [_colorView.layer addSublayer:_colorLayer];
    
    _triangleWidth = (self.bounds.size.height * kTriangleWidthFactor); //width in terms of view, in geometric terms - height
    
    _colorLayer.path = [self drawArrowPath].CGPath;
    [_colorLayer setPosition:CGPointMake(self.frame.size.width/2,
                                         self.frame.size.height/2)];
    
    [self setUpCircles];
    
    if (!_isQuestion)
    {
        [self transformToAnswer];
    }
    else
    {
        if (_highlightColor == nil)
        {
            const CGFloat hueStep = (360./(CGFloat)totalQuestions)/360.;
            const CGFloat estimatedHue = 165./360. + hueStep * (CGFloat)index;
            
            _highlightColor = [UIColor colorWithHue:estimatedHue <= 1. ? estimatedHue : estimatedHue - 1. saturation:kQAActiveColorSaturation brightness:1 alpha:1];
        }
    }
    
    [self addSubview:_textLabel];
}

- (void)setUpCircles
{
    if (!_useCirclesOnLineConnectionPoints)
    {
        return;
    }
    
    _circleLayer = [[CAShapeLayer alloc] init];
    _circleLayer.contentsGravity = kCAGravityResizeAspect;
    _circleLayer.bounds = CGRectMake(0,
                                     0,
                                     self.bounds.size.height/7.,
                                     self.bounds.size.height/7.);
    _circleLayer.fillColor = _annotationColor.CGColor;
    _circleLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_circleLayer.bounds.size.width / 2., _circleLayer.bounds.size.width / 2.)
                                                       radius:(_circleLayer.bounds.size.width / 2.)
                                                   startAngle:0
                                                     endAngle:(2 * M_PI)
                                                    clockwise:YES].CGPath;
    [_circleLayer setPosition:CGPointMake(self.frame.size.width,
                                          self.frame.size.height/2)];
    [_colorView.layer addSublayer:_circleLayer];
}

- (void)transformToAnswer
{
    _colorView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _colorView.frame = self.bounds;
    _triangleWidth = (self.bounds.size.height * kTriangleWidthFactor);
    
     [_textLabel sizeToFit];
    CGFloat margin = self.frame.size.width * 0.1;
    _textLabel.frame = CGRectMake(_isQuestion ? margin : margin + _triangleWidth,
                                  self.frame.size.height/2. - _textLabel.frame.size.height/2.,
                                  _textLabel.frame.size.width,
                                  _textLabel.frame.size.height);

    
    // animate layer transformation
    
    _triangleWidth = (self.bounds.size.height * kTriangleWidthFactor); //width in terms of view, in geometric terms - height
    _colorLayer.path = [self drawArrowPath].CGPath;
    
    if (_useCirclesOnLineConnectionPoints)
    {
        _circleLayer.bounds = CGRectMake(0,
                                         0,
                                         self.bounds.size.height/7.,
                                         self.bounds.size.height/7.);
        _circleLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_circleLayer.bounds.size.width / 2., _circleLayer.bounds.size.width / 2.)
                                                           radius:(_circleLayer.bounds.size.width / 2.)
                                                       startAngle:0
                                                         endAngle:(2 * M_PI)
                                                        clockwise:YES].CGPath;
        [_circleLayer setPosition:CGPointMake(self.frame.size.width,
                                              self.frame.size.height/2)];
    }
  
    if (_gradientLayer != nil)
    {
        [self drawGradientWithColors:nil]; // passing nil uses color, that are already there
    }
    
}

- (void)updateConnectionFromParent:(UIScrollView *)parent toView:(QAItemView *)view inScroller:(UIScrollView *)partner
{
    if (_connectedViewsIndexes == nil)
    {
        _connectedViewsIndexes = [[NSMutableIndexSet alloc] init];
    }
   
    if (!_isQuestion)
    {
        [self updateAnnotationColorWithColor: view.highlightColor fromIndex:view.index];
    }
    else
    {
        [view updateConnectionFromParent:partner
                                  toView:self
                              inScroller:parent];
    }
    
    BOOL disconneting = [_connectedViewsIndexes containsIndex:view.index];
    
    if (disconneting)
    {
        [_connectedViewsIndexes removeIndex: view.index];
        
        NSNumber* proposedConnectionViewKey = [NSNumber numberWithInteger:view.index];
        
        if (_isQuestion) {
            QAConnectingLine* line = _lines[proposedConnectionViewKey];
            [line.lineLayer removeFromSuperlayer];
            [_lines removeObjectForKey:proposedConnectionViewKey];
        }
    }
    else
    {
        [_connectedViewsIndexes addIndex: view.index];
        if (_isQuestion)
        {
            CGFloat targetPointVisiblePosition = view.center.y - partner.contentOffset.y;
            CGFloat sourcePointVisiblePosition = self.center.y - parent.contentOffset.y;
            CGFloat targetPointInCoordinateOfThisInstance =
                targetPointVisiblePosition - sourcePointVisiblePosition;
            CGFloat gap = (parent.contentSize.width - (self.frame.origin.x + self.frame.size.width)) * 2. + _connectingLineWidth;
            
            [self drawLineToViewAtPointY:targetPointInCoordinateOfThisInstance
                                forIndex:view.index
                           withMaxHeight:partner.contentSize.height + partner.contentSize.height
                                     gap:gap
                                animated:YES];
        }
    }
}

- (void)redrawConnectionsFromParent:(UIScrollView *)parent toViews:(NSSet *)views inScroller:(UIScrollView *)partner
{
    for (QAItemView* view in views)
    {
        CGFloat targetPointVisiblePosition = view.center.y - partner.contentOffset.y;
        CGFloat sourcePointVisiblePosition = self.center.y - parent.contentOffset.y;
        CGFloat targetPointInCoordinateOfThisInstance =
            targetPointVisiblePosition - sourcePointVisiblePosition;
        CGFloat gap = (parent.contentSize.width - (self.frame.origin.x + self.frame.size.width)) * 2. + _connectingLineWidth;
        
        [self drawLineToViewAtPointY:targetPointInCoordinateOfThisInstance
                            forIndex:view.index
                       withMaxHeight:partner.contentSize.height + partner.contentSize.height
                                 gap:gap
                            animated:NO];
    }
}


- (void)highlight
{
    _annotationColor = _isActive ? _highlightColor :
      _inactiveColor != nil ? _inactiveColor : [UIColor colorWithHue:0 saturation:0 brightness:kQAInactiveColorBrightness alpha:1];
    
    _colorLayer.fillColor = _annotationColor.CGColor;
    if (_useCirclesOnLineConnectionPoints) {
        _circleLayer.fillColor = _annotationColor.CGColor;
    }
}

- (void)relightenWithColor:(UIColor*)color;
{
    _annotationColor = color;
    _colorLayer.fillColor = _annotationColor.CGColor;
    if (_useCirclesOnLineConnectionPoints) {
        _circleLayer.fillColor = _annotationColor.CGColor;
    }
}

- (void)shutQuestion
{
    _isActive = false;
    _annotationColor = _inactiveColor != nil ? _inactiveColor : [UIColor colorWithHue:0 saturation:0 brightness:kQAInactiveColorBrightness alpha:1];
    _colorLayer.fillColor = _annotationColor.CGColor;
    if (_useCirclesOnLineConnectionPoints) {
        _circleLayer.fillColor = _annotationColor.CGColor;
    }
}

- (void)blink
{
    __weak typeof(self) welf = self;
    [UIView animateWithDuration:0.2 animations:^{
        welf.alpha = 0;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            welf.alpha = 1;
        } completion:nil];
    }];
}

- (void)updateAnnotationColorWithColor:(UIColor *)color fromIndex:(NSUInteger)index // called only if item is Answer
{
    if (_colorsOfConnectedQuestions == nil)
    {
        _colorsOfConnectedQuestions = [[NSMutableDictionary alloc] init];
    }
    
    NSNumber* indexNumber = [NSNumber numberWithInteger:index];
    
    if (_colorsOfConnectedQuestions[indexNumber] == nil)
    {
        [_colorsOfConnectedQuestions setObject:(id)color.CGColor forKey:indexNumber];
        if ([_colorsOfConnectedQuestions count] > 1)
        {
            [self drawGradientWithColors:[_colorsOfConnectedQuestions allValues]];
            
            _annotationColor = color;
            _colorLayer.fillColor = _annotationColor.CGColor;

            if (_useCirclesOnLineConnectionPoints) {
                _circleLayer.fillColor = _annotationColor.CGColor;
            }
        }
        else
        {
            _annotationColor = color;
            _colorLayer.fillColor = _annotationColor.CGColor;
            
            if (_useCirclesOnLineConnectionPoints) {
                _circleLayer.fillColor = _annotationColor.CGColor;
            }
        }
    }
    else //already has this color
    {
        [_colorsOfConnectedQuestions removeObjectForKey:indexNumber];
        
        NSArray* allConnectedColors = [_colorsOfConnectedQuestions allValues];
        
        if ([_colorsOfConnectedQuestions count] != 0)
        {
            if ([_colorsOfConnectedQuestions count] == 1)
            {
                _annotationColor = [UIColor colorWithCGColor:(__bridge CGColorRef)(allConnectedColors[0])];
                _colorLayer.fillColor = _annotationColor.CGColor;
                
                if (_useCirclesOnLineConnectionPoints) {
                    _circleLayer.fillColor = _annotationColor.CGColor;
                }
                
                if (_useGradients)
                {
                    [_gradientLayer removeFromSuperlayer];
                    _gradientLayer = nil;
                    _gradientMaskLayer = nil;
                }
            }
            else
            {
                [self drawGradientWithColors:allConnectedColors];
                _annotationColor = [UIColor colorWithCGColor:(__bridge CGColorRef)(allConnectedColors[0])];
                 _colorLayer.fillColor = _annotationColor.CGColor;
                
                if (_useCirclesOnLineConnectionPoints) {
                    _circleLayer.fillColor = _annotationColor.CGColor;
                }
            }
        }
        else
        {
            _annotationColor = _inactiveColor != nil ? _inactiveColor : [UIColor colorWithHue:0 saturation:0 brightness:kQAInactiveColorBrightness alpha:1];
            _colorLayer.fillColor = _annotationColor.CGColor;
            
            if (_useCirclesOnLineConnectionPoints) {
                _circleLayer.fillColor = _annotationColor.CGColor;
            }
        }
    }
}

- (void)drawGradientWithColors:(NSArray *)colors
{
    if (!_useGradients) {
        return;
    }
    
    if (_gradientLayer == nil)
    {
        _gradientLayer = [[CAGradientLayer alloc] init];
        _gradientMaskLayer = [[CAShapeLayer alloc] init];
        
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"onOrderIn", //disable animation for keys
                                           [NSNull null], @"onOrderOut",
                                           [NSNull null], @"sublayers",
                                           [NSNull null], @"contents",
                                           [NSNull null], @"bounds",
                                           [NSNull null], @"position",
                                           nil];
        _gradientMaskLayer.actions = newActions;
        _gradientLayer.actions = newActions;
        
        [_colorLayer addSublayer:_gradientLayer];
    }
   
    if (colors != nil)
    {
        _gradientLayer.colors = colors;
    }
    
    // Hoizontal - commenting these two lines will make the gradient veritcal
    /*
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    */
    
    NSNumber* gradTopStart = [NSNumber numberWithFloat:0.0];
    NSMutableArray *locations = [NSMutableArray arrayWithObjects:gradTopStart, nil];
    
    NSInteger colorsCount = [colors count];
    if (colorsCount > 2) {
        CGFloat gradientStep = 1./(CGFloat)(colorsCount - 1);
        
        for (CGFloat currentGradPos = gradientStep; currentGradPos < 1.; currentGradPos += gradientStep) {
            NSNumber* gradNextStep = [NSNumber numberWithFloat:currentGradPos];
            [locations addObject:gradNextStep];
        }
    }
    
    NSNumber* gradBottomEnd = [NSNumber numberWithFloat:1.0];
    [locations addObject:gradBottomEnd];
    _gradientLayer.locations = [NSArray arrayWithArray:locations];
    
    
    _gradientMaskLayer.path = [self drawArrowPath].CGPath;
    [_gradientMaskLayer setPosition:CGPointMake(self.frame.size.width/2,
                                         self.frame.size.height/2)];
    _gradientMaskLayer.frame = self.bounds;
    _gradientLayer.bounds = self.bounds;
    _gradientLayer.mask = _gradientMaskLayer;
    _gradientLayer.anchorPoint = CGPointZero;
}

- (BOOL)hasViewsConnected
{
    return [_connectedViewsIndexes count] > 0;
}

#pragma mark - Helpers

- (UIBezierPath *)drawArrowPath
{
    CGRect bounds = self.bounds;
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(bounds.size.width - _triangleWidth,0)];
    [path addLineToPoint:CGPointMake(bounds.size.width, bounds.size.height/2)];
    [path addLineToPoint:CGPointMake(bounds.size.width - _triangleWidth, bounds.size.height)];
    [path addLineToPoint:CGPointMake(0, bounds.size.height)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path closePath];
    return path;
}

#pragma mark - Lines drawing

- (void)drawLineToViewAtPointY:(CGFloat)targetViewPosY
                      forIndex:(NSUInteger)index
                 withMaxHeight:(CGFloat)maxHeight
                           gap:(CGFloat)gap
                      animated:(BOOL)animated
{
    CGPoint target = CGPointMake(gap, targetViewPosY);
    CGPoint ctrlPoint1 = CGPointMake(gap, 0);
    CGPoint ctrlPoint2 = CGPointMake(0, targetViewPosY);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    
    if (_useCurvesInConnection)
    {
        [path addCurveToPoint:target
                controlPoint1:ctrlPoint1
                controlPoint2:ctrlPoint2];
    }
    else
    {
        [path addLineToPoint:target];
    }
    
    CAShapeLayer* lineLayer;
    
    if (_lines == nil)
    {
        _lines = [[NSMutableDictionary alloc] init];
    }
    
    NSNumber* key = [NSNumber numberWithInteger:index];
    
    if (_lines[key] == nil)
    {
        lineLayer = [CAShapeLayer layer];
        lineLayer.strokeColor = _annotationColor.CGColor;
        lineLayer.fillColor = nil;
        lineLayer.lineWidth = _connectingLineWidth;
        lineLayer.lineJoin = kCALineJoinBevel;
    }
    else
    {
        QAConnectingLine* oldLine = _lines[key];
        lineLayer = oldLine.lineLayer;
    }
    
    lineLayer.frame = CGRectMake(0,
                                 0,
                                 gap,
                                 maxHeight);
    lineLayer.path = path.CGPath;
    [lineLayer setPosition:CGPointMake(self.frame.size.width + lineLayer.frame.size.width/2. - lineLayer.lineWidth/2.,
                                         self.frame.size.height/2. + lineLayer.frame.size.height/2.)];
    
    QAConnectingLine* newLine = [[QAConnectingLine alloc] initWithLayer:lineLayer
                                                                 target:target
                                                             ctrlPoint1:ctrlPoint1
                                                             ctrlPoint2:ctrlPoint2];
    
    [_lines setObject:newLine forKey:key];
    
    [_colorView.layer addSublayer:lineLayer];
    
    if (animated)
    {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = _connectingAnimationDuration;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [lineLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    }
}

- (void)updateLinesWithTranslation:(CGFloat)translation
{
    for (QAConnectingLine* line in [_lines allValues])
    {
        line.target = CGPointMake(line.target.x, line.target.y + translation);
        line.ctrlPoint2 = CGPointMake(line.ctrlPoint2.x, line.ctrlPoint2.y + translation);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointZero];
        
        if (_useCurvesInConnection)
        {
            [path addCurveToPoint:line.target
                    controlPoint1:line.ctrlPoint1
                    controlPoint2:line.ctrlPoint2];
        }
        else
        {
            [path addLineToPoint:line.target];
        }
        
        line.lineLayer.path = path.CGPath;
    }
}

@end
