//
//  QAItemView.h
//  QATrinity
//
//  Created by Admin on 18.02.16.
//  Copyright (c) 2016 PinkStyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollViewItem.h"

extern CGFloat const kItemToParentScrollViewWidthFactor;

@interface QAItemView : UIScrollViewItem

// Customizible -- start
@property (strong, nonatomic) UIColor* highlightColor;
@property (strong, nonatomic) UIColor* inactiveColor;;
@property (strong, nonatomic) UILabel* textLabel;

@property (nonatomic) CFTimeInterval connectingAnimationDuration;
@property (nonatomic) CGFloat connectingLineWidth;
@property (nonatomic) BOOL useGradients;
@property (nonatomic) BOOL useCirclesOnLineConnectionPoints;
@property (nonatomic) BOOL useCurvesInConnection;
 
// Customizible -- end

@property (nonatomic) NSUInteger index;
@property (nonatomic) BOOL isQuestion;
@property (nonatomic) BOOL isActive;
@property (nonatomic) BOOL hasViewsConnected;
@property (nonatomic) NSMutableIndexSet* connectedViewsIndexes;

- (id)initWithFrame:(CGRect)frame text:(NSString*)text
                                 index:(NSInteger)index
                        totalQuestions:(NSInteger)totalQuestions
                         inactiveColor:(UIColor*)inactiveColor
                           activeColor:(UIColor*)activeColor
                            asQuestion:(BOOL)asQuestion;
// number of colors = number of question items. Each question has unique color.
// step is Hue is defined in .m file

- (void)highlight;
- (void)shutQuestion;
- (void)blink;
- (void)relightenWithColor:(UIColor*)color;

- (void)updateConnectionFromParent:(UIScrollView *)parent toView:(QAItemView *)view inScroller:(UIScrollView *)partner;
- (void)redrawConnectionsFromParent:(UIScrollView *)parent toViews:(NSSet *)views inScroller:(UIScrollView *)partner;

- (void)updateLinesWithTranslation:(CGFloat)translation;

- (void)setUpWithIndex:(NSUInteger)index ofTotalQuestions:(NSUInteger)totalQuestions;

@end
