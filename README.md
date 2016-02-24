# QAView

[![Version](https://img.shields.io/cocoapods/v/QAView.svg?style=flat)](http://cocoapods.org/pods/QAView)
[![License](https://img.shields.io/cocoapods/l/QAView.svg?style=flat)](http://cocoapods.org/pods/QAView)
[![Platform](https://img.shields.io/cocoapods/p/QAView.svg?style=flat)](http://cocoapods.org/pods/QAView)

![](QAScreenshot.gif?raw=true "Blinking Label screenshot")

QAView represents 2 UIScrollViews:` _questionsScroller` & `_answersScroller` populated with 2 arrays: `_questions` & `_answers` respectively. When a question is tapped, it becomes active and ready to be connected to answers. Use this pod whenever you have to visualize dependencies in between elements of 2 arrays.

## Requirements
* iOS 7 - if install manually
* iOS 8 - if use CocoaPods

## Installation

### Manual

Just drag and drop the `QAView/QAView` folder into your project.

### CocoaPods

QAView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "QAView"
```

## Usage

### Set up

Set up is easy as
```objc
_qaView = [[QAView alloc] initWithFrame:self.view.frame
                                  questions:@[@"Frank",
                                              @"Jason"]
                                    answers:@[@"Anna",
                                              @"Maria",
                                              @"Jessica"]];
```
You can set highlight colors
```objc
_qaView.colors = @[[UIColor greenColor], [UIColor purpleColor]];
```
If not set, highlight colors are generated automatically with hue step = `(360./[questions count])/360.`

You can set inactive color
```objc
_qaView.inactiveColor = [UIColor redColor];
```
Default is gray with lightness = `0.89`
    
Set logic scheme
```objc
_qaView.canUseOneAnswerToSeveralQuestions = NO; //Defaults to YES
_qaView.canUseSeveralAnswersToOneQuestion = NO; //Defaults to YES
```

### Delegate

You can set whatever you like as QAView delegate
```objc
_qaView.delegate = self;
``` 

To do this, adopt `<QAViewDelegate>` protocol.
It has following `@optional` methods:

```objc
- (void)didRecieveTapInAnswerView:(QAItemView *)view;
- (void)didRecieveTapInQuestionView:(QAItemView *)view;

- (void)answersScrollerDidScroll:(QAScrollView *)scrollView;
- (void)questionsScrollerDidScroll:(QAScrollView *)scrollView;

- (QAItemView *)itemViewForAnswerAtIndex:(NSUInteger)index; 	//cutom cell set up
- (QAItemView *)itemViewForQuestionAtIndex:(NSUInteger)index;	//custom cell set up

- (NSUInteger)numberOfAnswers;
- (NSUInteger)numberOfQuestions;
```

### Custom cell set up

Following cell (`QAItemView`) propeties are designed for custom set up:
```objc
@property (strong, nonatomic) UIColor* highlightColor;
@property (strong, nonatomic) UIColor* inactiveColor;;
@property (strong, nonatomic) UILabel* textLabel;

@property (nonatomic) CFTimeInterval connectingAnimationDuration;
@property (nonatomic) CGFloat connectingLineWidth;
@property (nonatomic) BOOL useGradients;
@property (nonatomic) BOOL useCirclesOnLineConnectionPoints;
@property (nonatomic) BOOL useCurvesInConnection;
```

Edit them when initilizing a QAItemView in `itemViewForAnswerAtIndex:` / `itemViewForQuestionAtIndex:`.

**Important**

When initilizing cell with `[[QAItemView alloc] init]` in `itemViewForAnswerAtIndex:` / `itemViewForQuestionAtIndex:`, **do not** set or retrieve its' frame, as the frame will be set automatically right after this method is called.

FOR MANUAL FRAME SET UP, use following initilizer:
```objc
- (id)initWithFrame:(CGRect)frame text:(NSString*)text
                                 index:(NSInteger)index
                        totalQuestions:(NSInteger)totalQuestions
                         inactiveColor:(UIColor*)inactiveColor
                           activeColor:(UIColor*)activeColor
                            asQuestion:(BOOL)asQuestion
```

For formula, used for automatic cell frame calculation check Example project.

### Retrieving data

Call methods of `QAView`

```objc
- (NSIndexSet*)connectedQuestionsIndexesForAnswerAtIndex:(NSUInteger)index;
- (NSIndexSet*)connectedAnswersIndexesForQuestionAtIndex:(NSUInteger)index;
```

## Author

Nikita Borisov https://twitter.com/nikita_kerd

## License

QAView is available under the MIT license. See the LICENSE file for more info.
