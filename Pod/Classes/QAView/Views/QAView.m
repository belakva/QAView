//
//  ViewController.m
//  QATrinity
//
//  Created by Admin on 18.02.16.
//  Copyright (c) 2016 PinkStyx. All rights reserved.
//

#import "QAView.h"

@interface QAView () <UIScrollViewDelegate, UIScrollViewItemDelegate>

@property (strong, nonatomic) QAScrollView* questionsScroller;
@property (strong, nonatomic) QAScrollView* answersScroller;

@end

@implementation QAView
{
    NSMutableArray* _questionViews;
    NSMutableArray* _answerViews;
    
    NSMutableDictionary* _connections; // @{indexOfQuestion:connectedAnswersIndexes}
}

#pragma mark - Initilizers

- (id)init
{
    self = [super init];
    if (self) {
        _canUseOneAnswerToSeveralQuestions = YES;
        _canUseSeveralAnswersToOneQuestion = YES;
        [self setUpScrollers];
    }
    return self;
}

- (id)initWithQuestions:(NSArray*)questions
            answers:(NSArray*)answers
{
    self = [super init];
    if (self) {
        _canUseOneAnswerToSeveralQuestions = YES;
        _canUseSeveralAnswersToOneQuestion = YES;
        [self setUpScrollers];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _canUseOneAnswerToSeveralQuestions = YES;
        _canUseSeveralAnswersToOneQuestion = YES;
        [self setUpScrollers];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
          questions:(NSArray*)questions
            answers:(NSArray*)answers
{
    self = [super initWithFrame:frame];
    if (self) {
        _questions = questions;
        _answers = answers;
        _canUseOneAnswerToSeveralQuestions = YES;
        _canUseSeveralAnswersToOneQuestion = YES;
        [self setUpScrollers];
        
    }
    return self;
}

- (void)setUpScrollers
{
    if (_questionsScroller != nil)
    {
        [_questionsScroller removeFromSuperview];
    }
    
    if (_answersScroller != nil)
    {
        [_answersScroller removeFromSuperview];
    }
    
    
    _questionsScroller = [[QAScrollView alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        self.bounds.size.width/2.,
                                                                        self.bounds.size.height)];
    _answersScroller = [[QAScrollView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2,
                                                                      0,
                                                                      self.bounds.size.width/2.,
                                                                      self.bounds.size.height)];
    
    _questionsScroller.delegate = self;
    _answersScroller.delegate = self;
    _questionsScroller.clipsToBounds = NO;
    
    _questionsScroller.showsHorizontalScrollIndicator = NO;
    _questionsScroller.showsVerticalScrollIndicator = NO;
    _questionsScroller.canCancelContentTouches = YES;
    _questionsScroller.delaysContentTouches = YES;
    
    _answersScroller.showsHorizontalScrollIndicator = NO;
    _answersScroller.showsVerticalScrollIndicator = NO;
    _answersScroller.canCancelContentTouches = YES;
    _answersScroller.delaysContentTouches = YES;
    
    [self addSubview:_questionsScroller];
    [self addSubview:_answersScroller];
    
    [self reload];
}

#pragma mark - Setters

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setUpScrollers];
}

- (void)setQuestions:(NSArray *)questions
{
    _questions = questions;
    [self reload];
}

- (void)setAnswers:(NSArray *)answers
{
    _answers = answers;
    [self reload];
}

- (void)setColors:(NSArray *)colors
{
    _colors = colors;
    [self reload];
}

- (void)setInactiveColor:(UIColor *)inactiveColor
{
    _inactiveColor = inactiveColor;
    [self reload];
}

#pragma mark - Public methods

- (NSIndexSet*)connectedQuestionsIndexesForAnswerAtIndex:(NSUInteger)index
{
    if ([_answerViews count] < index && _answerViews[index] != nil)
    {
        QAItemView* answer = _answerViews[index];
        return answer.connectedViewsIndexes;
    }
    else
    {
        return nil;
    }
}

- (NSIndexSet*)connectedAnswersIndexesForQuestionAtIndex:(NSUInteger)index
{
    if ([_questionViews count] < index && _questionViews[index] != nil)
    {
        QAItemView* question = _questionViews[index];
        return question.connectedViewsIndexes;
    }
    else
    {
        return nil;
    }
}

- (void)reload
{
    NSInteger answersCount;
    NSInteger questionsCount;
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(numberOfAnswers)])
    {
        answersCount = [_delegate numberOfAnswers];
    }
    else
    {
        answersCount = [_answers count];
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(numberOfQuestions)])
    {
        questionsCount = [_delegate numberOfQuestions];
    }
    else
    {
        questionsCount = [_questions count];
    }
    
    if (questionsCount == 0 || answersCount == 0) {
        return;
    }
    
    if (_questionViews == nil)
    {
        _questionViews = [[NSMutableArray alloc] init];
    }
    else // remove all
    {
        for (QAItemView* view in _questionViews)
        {
            [view removeFromSuperview];
        }
        [_questionViews removeAllObjects];
    }
    
    if (_answerViews == nil)
    {
        _answerViews = [[NSMutableArray alloc] init];
    }
    else
    {
        for (QAItemView* view in _answerViews)
        {
            [view removeFromSuperview];
        }
        [_answerViews removeAllObjects];
    }
    
    // add new views and reposition old views if needed
    // first answers, because will need their updated positions when redraw connection lines
    
    CGFloat horizontalMargin = _questionsScroller.frame.size.width * 0.1;
    CGFloat verticalMargin = _questionsScroller.frame.size.width * 0.1; 
    CGFloat itemWidth = _questionsScroller.frame.size.width * kItemToParentScrollViewWidthFactor; //const defined in QAItemView.h
    CGFloat itemHeight = _questionsScroller.frame.size.width * 0.3;
    
    CGFloat pageHeight = itemHeight + verticalMargin;
    
    _questionsScroller.contentSize = CGSizeMake(_questionsScroller.frame.size.width,
                                                pageHeight * (CGFloat)questionsCount + verticalMargin);
    _answersScroller.contentSize = CGSizeMake(_answersScroller.frame.size.width,
                                              pageHeight * (CGFloat)answersCount + verticalMargin);
   
    for (NSUInteger index = 0; index < answersCount; index++)
    {
        
        CGRect newFrame = CGRectMake(_answersScroller.frame.size.width - itemWidth - horizontalMargin,
                                     verticalMargin + ((CGFloat)index * (itemHeight + verticalMargin)),
                                     itemWidth,
                                     itemHeight);
        
        QAItemView* itemView;
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(itemViewForAnswerAtIndex:)])
        {
            itemView = [_delegate itemViewForAnswerAtIndex:index];
        }
        
        if (itemView == nil)
        {
            itemView = [[QAItemView alloc] initWithFrame:newFrame
                                                    text:[_answers count] > index ? _answers[index] : nil
                                                   index:index
                                          totalQuestions:0
                                           inactiveColor:_inactiveColor
                                             activeColor:nil
                                              asQuestion:NO];
        }
        else if (itemView.frame.size.width == 0) //frame not set, cell passed from delegate
        {
            itemView.frame = newFrame;
            itemView.index = index;
            itemView.isQuestion = NO;
            
            if (itemView.inactiveColor == nil) {
                itemView.inactiveColor = _inactiveColor;
            }
            
            [itemView setUpWithIndex:index ofTotalQuestions:0];
        }
        
        itemView.delegate = self;
        
        [_answerViews addObject:itemView];
        
        itemView.alpha = 0;
        [_answersScroller addSubview:itemView];
        [UIView animateWithDuration:0.3 animations:^{
            itemView.alpha = 1;
        }];
    }
    
    
    for (NSUInteger index = 0; index < questionsCount; index++)
    {
        CGRect newFrame = CGRectMake(horizontalMargin,
                                     verticalMargin + ((CGFloat)index * (itemHeight + verticalMargin)),
                                     itemWidth,
                                     itemHeight);
        
        QAItemView* itemView;
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(itemViewForQuestionAtIndex:)])
        {
            itemView = [_delegate itemViewForQuestionAtIndex:index];
        }
        
        UIColor* activeColor = nil;
        if ((itemView == nil || itemView.frame.size.width == 0) && _colors != nil)
        {
            NSInteger colorsCount = [_colors count];
            
            if (colorsCount > (int)index)
            {
                activeColor = _colors[(int)index];
            }
            else if (colorsCount > 0)
            {
                NSInteger colorIndex = (NSInteger)index;
                
                while (colorIndex >= colorsCount)
                {
                    colorIndex -= colorsCount;
                }
                activeColor = _colors[colorIndex];
                
            }
        }
        
        if (itemView == nil)
        {
            itemView = [[QAItemView alloc] initWithFrame:newFrame
                                                    text:[_questions count] > index ? _questions[index] : nil
                                                   index:index
                                          totalQuestions:_maxQuestionsPerPage > 0 ? _maxQuestionsPerPage : questionsCount
                                           inactiveColor:_inactiveColor
                                             activeColor:activeColor
                                              asQuestion:YES];
        }
        else if (itemView.frame.size.width == 0) //frame not set, cell passed from delegate
        {
            itemView.frame = newFrame;
            itemView.index = index;
            itemView.isQuestion = YES;
            
            if (itemView.inactiveColor == nil) {
                itemView.inactiveColor = _inactiveColor;
            }
            
            if (itemView.highlightColor == nil) {
                itemView.highlightColor = activeColor;
            }
            
            [itemView setUpWithIndex:index ofTotalQuestions:_maxQuestionsPerPage > 0 ? _maxQuestionsPerPage : questionsCount];
        }
        
        itemView.delegate = self;
        
        [_questionViews addObject:itemView];
        
        itemView.alpha = 0;
        [_questionsScroller addSubview:itemView];
        [UIView animateWithDuration:0.3 animations:^{
            itemView.alpha = 1;
        }];
        
        // redraw connections
        NSNumber* numberWithIndex = [NSNumber numberWithInteger:index];
        if (_connections != nil && _connections[numberWithIndex] != nil)
        {
            itemView.connectedViewsIndexes = _connections[numberWithIndex];
        }
        
        if ([itemView hasViewsConnected])
        {
            [itemView relightenWithColor:itemView.highlightColor];
            NSUInteger answerViewsCount = [_answerViews count];
            NSMutableSet* connectedAnswers = [NSMutableSet set];
            
            [itemView.connectedViewsIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                
                if (answerViewsCount > idx && _answerViews[idx] != nil)
                {
                    QAItemView* answerView = _answerViews[idx];
                    [connectedAnswers addObject:answerView];
                    [answerView relightenWithColor:itemView.highlightColor];
                }
            }];
            [itemView redrawConnectionsFromParent:_questionsScroller
                                          toViews:connectedAnswers
                                       inScroller:_answersScroller];
        }
    }

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(QAScrollView *)scrollView
{
    CGFloat translation;
    
     if (scrollView == _answersScroller)
     {
        translation = scrollView.oldOffsetY - scrollView.contentOffset.y;
         
         if (_delegate != nil && [_delegate respondsToSelector:@selector(answersScrollerDidScroll:)])
         {
             [_delegate answersScrollerDidScroll:scrollView];
         }
     }
    else
    {
       translation = scrollView.contentOffset.y - scrollView.oldOffsetY;
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(questionsScrollerDidScroll:)])
        {
            [_delegate questionsScrollerDidScroll:scrollView];
        }
    }
    
    if (translation == 0)
    {
        return;
    }
    
    scrollView.oldOffsetY = scrollView.contentOffset.y;
    
    for (QAItemView* question in _questionViews)
    {
        if ([question hasViewsConnected]) {
            [question updateLinesWithTranslation:translation];
        }
    }
}

#pragma mark - UIScrollViewItemDelegate

- (void)didRecieveTapInUIScrollViewItemView:(QAItemView *)itemView
{
    if (itemView.isQuestion)
    {
        if ([itemView hasViewsConnected])
        {
            if (itemView.isActive)
            {
                [itemView.connectedViewsIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                    
                    QAItemView* answerView = _answerViews[idx];
                    [itemView updateConnectionFromParent:_questionsScroller
                                                  toView:answerView
                                              inScroller:_answersScroller];
                    [self removeConnectionOfAnswerAtIndex:idx toQuestionAtIndex:itemView.index];
                }];
            }
            else // not active, but has views connected
            {
                itemView.isActive = YES;
                [itemView blink];
                
                for (QAItemView* item in _questionViews)
                {
                    if (itemView != item)
                    {
                        item.isActive = NO;
                        
                        if (![item hasViewsConnected])
                        {
                            [item shutQuestion];
                        }
                    }
                }
            }
        }
        else //has no views connected
        {
            if (itemView.isActive)
            {
                [itemView blink];
            }
            else
            {
                itemView.isActive = YES;
                [itemView highlight];
            }
            
            for (QAItemView* item in _questionViews)
            {
                if (itemView != item)
                {
                    item.isActive = NO;
                    
                    if (![item hasViewsConnected])
                    {
                        [item shutQuestion];
                    }
                }
            }
        }
        
        _questionsScroller.canCancelContentTouches = YES;
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(didRecieveTapInQuestionView:)])
        {
            [_delegate didRecieveTapInQuestionView:itemView];
        }
    }
    
    else // tapped answer
    {
        for (QAItemView* item in _questionViews) {
            if (item.isActive)
            {
                if (!_canUseSeveralAnswersToOneQuestion)
                {
                    [item.connectedViewsIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                        
                        QAItemView* answerView = _answerViews[idx];
                        [item updateConnectionFromParent:_questionsScroller
                                                      toView:answerView
                                                  inScroller:_answersScroller];
                        [self removeConnectionOfAnswerAtIndex:idx toQuestionAtIndex:item.index];
                    }];
                }
                
                [item updateConnectionFromParent:_questionsScroller
                                          toView:itemView
                                      inScroller:_answersScroller];
                [self addConnectionOfAnswerAtIndex:itemView.index toQuestionAtIndex:item.index];
                
            }
            else if (!_canUseOneAnswerToSeveralQuestions && [item hasViewsConnected] && [item.connectedViewsIndexes containsIndex:itemView.index])
            {
                [item updateConnectionFromParent:_questionsScroller
                                          toView:itemView
                                      inScroller:_answersScroller];
                [self removeConnectionOfAnswerAtIndex:item.index toQuestionAtIndex:itemView.index];
                
                if (![item hasViewsConnected]) {
                    [item shutQuestion];
                }
            }
        }
        
        _answersScroller.canCancelContentTouches = YES;
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(didRecieveTapInAnswerView:)])
        {
            [_delegate didRecieveTapInAnswerView:itemView];
        }
    }
}

- (void)addConnectionOfAnswerAtIndex:(NSUInteger)answerIndex toQuestionAtIndex:(NSUInteger)questionIndex
{
    if (_connections == nil)
    {
        _connections = [[NSMutableDictionary alloc] init];
    }
    
    NSNumber* question = [NSNumber numberWithInteger:questionIndex];
    
    if (_connections[question] == nil)
    {
        [_connections setObject:[NSMutableIndexSet indexSet] forKey:question];
    }
    
    NSMutableIndexSet* questionConnections = _connections[question];
    [questionConnections addIndex:answerIndex];
}


- (void)removeConnectionOfAnswerAtIndex:(NSUInteger)answerIndex toQuestionAtIndex:(NSUInteger)questionIndex
{
    if (_connections == nil)
    {
        return;
    }
    
    NSNumber* question = [NSNumber numberWithInteger:questionIndex];
    
    if (_connections[question] == nil)
    {
        return;
    }
    
    NSMutableIndexSet* questionConnections = _connections[question];
    [questionConnections removeIndex:answerIndex];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
