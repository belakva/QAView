//
//  ViewController.h
//  QATrinity
//
//  Created by Admin on 18.02.16.
//  Copyright (c) 2016 PinkStyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAViewDelegate.h"
#import "QAItemView.h"
#import "QAScrollView.h"

@interface QAView : UIView

@property (weak, nonatomic) id<QAViewDelegate> delegate;

@property (strong, nonatomic) NSArray* questions;   // [NSString]
@property (strong, nonatomic) NSArray* answers;     // [NSString]

@property (nonatomic) NSInteger maxQuestionsPerPage;
@property (strong, nonatomic) UIColor* inactiveColor;
@property (strong, nonatomic) NSArray* colors;      // [UIColor] - use to set custom colors for questions. If not set, colors are generated with kHueStep derived from maxQuestionsPerPage

@property (nonatomic) BOOL canUseSeveralAnswersToOneQuestion;       //defaults to YES   
@property (nonatomic) BOOL canUseOneAnswerToSeveralQuestions;       //defaults to YES


- (id)initWithQuestions:(NSArray*)questions
                answers:(NSArray*)answers;

- (id)initWithFrame:(CGRect)frame
          questions:(NSArray*)questions
            answers:(NSArray*)answers;

- (void)setUpScrollers;

- (NSIndexSet*)connectedQuestionsIndexesForAnswerAtIndex:(NSUInteger)index;
- (NSIndexSet*)connectedAnswersIndexesForQuestionAtIndex:(NSUInteger)index;

@end


/* -- Important --
 
 Cells are not reused!
 
 It is so for the sake of simplifing connection drawing for cells out of screen.
 
 Moreover, for the sake of sanity one would doubtfully set more than 30 question-answer pairs,
 as it would be really hard for user to read all the connections, once they are made.
 
 */
