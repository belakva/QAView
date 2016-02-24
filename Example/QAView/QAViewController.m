//
//  QAViewController.m
//  QAView
//
//  Created by belakva on 02/23/2016.
//  Copyright (c) 2016 belakva. All rights reserved.
//

#import "QAViewController.h"
#import "QAView.h"

@interface QAViewController () <QAViewDelegate>

@end

@implementation QAViewController {
    
    QAView* _qaView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _qaView = [[QAView alloc] initWithFrame:self.view.frame
                                  questions:@[@"Frank",
                                              @"Jason",
                                              @"Howard",
                                              @"Question 4",
                                              @"Question 5",
                                              @"John",
                                              @"Gregory",
                                              @"Ronald",
                                              @"Bob"]
                                    answers:@[@"Anna",
                                              @"Maria",
                                              @"Jessica",
                                              @"Alina",
                                              @"Anastasia",
                                              @"Daisy",
                                              @"Nina",
                                              @"Polina",
                                              @"Barbara",
                                              @"Jim"]];
    _qaView.backgroundColor = [UIColor whiteColor];
    
    // Set highlight colors
    //_qaView.colors = @[[UIColor greenColor], [UIColor purpleColor]];
    
    // Set inactive color
    //_qaView.inactiveColor = [UIColor redColor];
    
    
    // Set logic scheme
    _qaView.canUseOneAnswerToSeveralQuestions = NO;
    _qaView.canUseSeveralAnswersToOneQuestion = YES;
    
    // For additinal set up
    _qaView.delegate = self;
    
    [self.view addSubview:_qaView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLayoutSubviews //handles screen rotations
{
    [super viewDidLayoutSubviews];
    
    _qaView.frame = self.view.frame;
}


#pragma mark - QAViewDelegate

- (NSUInteger)numberOfQuestions
{
    return 13;
}


/* Item frame formula
 
 CGFloat scrollerWidth = _qaView.frame.size.width * 0.5;
 
 CGFloat itemHeight = scrollerWidth * 0.3;
 CGFloat itemWidth = scrollerWidth * kItemToParentScrollViewWidthFactor; //const defined in QAItemView.h, 0.8 by default
 
 CGFloat horizontalMargin = scrollerWidth * 0.1; //margin between item and screen bounds
 CGFloat verticalMargin = scrollerWidth * 0.1; // margin between items
 
 */

- (QAItemView *)itemViewForQuestionAtIndex:(NSUInteger)index //Customizing cells
{
    
    if (index == 3)
    {
        QAItemView* customItemView = [[QAItemView alloc] init]; // no need to set frame here: it will be set automaticallly AFTER this method is called - see formula above ^^
        
        customItemView.textLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:20];
        customItemView.textLabel.textColor = [UIColor redColor];
        customItemView.textLabel.text = @"Donnie";
        customItemView.useCurvesInConnection = NO;
        customItemView.useCirclesOnLineConnectionPoints = NO;
        customItemView.highlightColor = [UIColor yellowColor];
        
        return customItemView;
    }
    else if (index == 4)
    {
        QAItemView* viewWithImage = [[QAItemView alloc] init];
        viewWithImage.connectingLineWidth = 6.;
        viewWithImage.highlightColor = [UIColor greenColor];
        
        UIImage* image = [UIImage imageNamed:@"sus_5"];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        CGFloat scrollerWidth = _qaView.frame.size.width * 0.5;
        CGFloat itemHeight = scrollerWidth * 0.3;
        CGFloat imageMargin = (itemHeight - imageView.frame.size.height)/2.;
        
        imageView.frame = CGRectMake(imageMargin,
                                     imageMargin,
                                     imageView.frame.size.width,
                                     imageView.frame.size.height);
        [viewWithImage addSubview:imageView];
        
        UILabel* gopherLbl = [[UILabel alloc] init];
        gopherLbl.text = @"Nikki";
        gopherLbl.font = [UIFont fontWithName:@"AmericanTypewriter" size:17];
        [gopherLbl sizeToFit];
        gopherLbl.center = CGPointMake(CGRectGetMaxX(imageView.frame) + imageMargin + gopherLbl.frame.size.width/2.,
                                       imageView.center.y);
        [viewWithImage addSubview:gopherLbl];
        
        return viewWithImage;
    }
    else
    {
        return nil;
    }
}
/*
- (QAItemView *)itemViewForAnswerAtIndex:(NSUInteger)index
{
    QAItemView* itemView = [[QAItemView alloc] init];
    itemView.textLabel.text = [NSString stringWithFormat:@"Answer %lu", (unsigned long)index + 1]; //when passing cell from this method, be sure to set text
    
    itemView.useGradients = NO;
    
    return itemView;
}*/
@end
