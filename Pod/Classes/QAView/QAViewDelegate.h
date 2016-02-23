//
//  QAViewDelegate.h
//  QATrinity
//
//  Created by Admin on 21.02.16.
//  Copyright (c) 2016 PinkStyx. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QAView;
@class QAItemView;
@class QAScrollView;

@protocol QAViewDelegate <NSObject>

@optional

- (void)didRecieveTapInAnswerView:(QAItemView *)view;
- (void)didRecieveTapInQuestionView:(QAItemView *)view;

- (void)answersScrollerDidScroll:(QAScrollView *)scrollView;
- (void)questionsScrollerDidScroll:(QAScrollView *)scrollView;

- (QAItemView *)itemViewForAnswerAtIndex:(NSUInteger)index;
- (QAItemView *)itemViewForQuestionAtIndex:(NSUInteger)index;

- (NSUInteger)numberOfAnswers;
- (NSUInteger)numberOfQuestions;

@end
