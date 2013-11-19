//
//  SingleGameViewController.m
//  VersusFlopGame
//
//  Created by Haoero on 13-11-17.
//  Copyright (c) 2013年 Haoero. All rights reserved.
//

#import "SingleGameViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "math.h"
@interface SingleGameViewController ()
{
    
    
}
@end

@implementation SingleGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController.navigationBar setHidden:YES];
    [self hideStatusBar]; // hide status bar
    [self initGameParameters];
    [self initUpFlopButtons];
    [self initDownFlopButtons];
}

//set statusbar hidden
-(void)hideStatusBar
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//YES to hide
}

-(void) initGameParameters
{
    isUpTouchOK = YES;
    isDownTouchOK = YES;
    
    CGRect windowRect = [[UIScreen mainScreen] bounds];
    halfWindowHeight = windowRect.size.height/2;
    windowWidth = windowRect.size.width;
    NSLog(@"halfHeight = %f width = %f" ,halfWindowHeight, windowWidth);
    rows = 4;
    cols = 6;
    buttonWidth = 80.0;
    buttonHeight = 80.0;
    buttonMargin = 10;
    marginSides = (windowWidth - buttonMargin*(cols-1) - buttonWidth*cols)/2;
    marginUp = (halfWindowHeight - buttonMargin*(rows-1) - buttonHeight*rows)/2;
    NSLog(@"marginSides = %f marginUp = %f" ,marginSides, marginUp);
    
    //draw lines
    [self drawLine:CGPointMake(0, marginUp) :CGPointMake(windowWidth, marginUp)];
    [self drawLine:CGPointMake(0, halfWindowHeight) :CGPointMake(windowWidth, halfWindowHeight)];
    [self drawLine:CGPointMake(0, halfWindowHeight-marginUp) :CGPointMake(windowWidth, halfWindowHeight-marginUp)];
    //center lines
    [self drawLine:CGPointMake(windowWidth/2, 0) :CGPointMake(windowWidth/2, halfWindowHeight*2)];
    [self drawLine:CGPointMake(0, halfWindowHeight) :CGPointMake(windowWidth, halfWindowHeight)];
    
    [self drawLine:CGPointMake(0, halfWindowHeight+marginUp) :CGPointMake(windowWidth, halfWindowHeight+marginUp)];
    [self drawLine:CGPointMake(0, halfWindowHeight*2-marginUp) :CGPointMake(windowWidth, halfWindowHeight*2-marginUp)];
    
    if(buttonImage_up== NULL){
		buttonImage_up = [UIImage imageNamed:@"cardCartoon.png" ];
	}
    if(buttonImage_down== NULL){
		buttonImage_down = [UIImage imageNamed:@"cardFruit.png" ];
	}
    
    [self addMenuViews];
    [self startNewGame];
    
}

//add menu views to main view
-(void)addMenuViews
{
    UIView *menuView_down = [[UIView alloc] initWithFrame:CGRectMake(0, halfWindowHeight, windowWidth, marginUp)];
    //set time label
    timeLabel_down = [[UILabel alloc] initWithFrame:CGRectMake(marginUp/2-20, marginUp/2-20, 100, 40)];
    timeLabel_down.backgroundColor = [UIColor clearColor];
    timeString = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    [timeLabel_down setText:timeString];
    [timeLabel_down setTextColor:[UIColor redColor]];
    [timeLabel_down setFont:[UIFont boldSystemFontOfSize:30]];
    //timeLabel_up.transform = CGAffineTransformMakeRotation(M_PI);
    [menuView_down addSubview:timeLabel_down];
    
    //add pause button
    UIImageView *pauseImage_down = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pause.png" ] highlightedImage:[UIImage imageNamed:@"pause_highligt.png" ]];
    [pauseImage_down setFrame:CGRectMake(windowWidth-100, 10, 80, 60)];
    pauseImage_down.userInteractionEnabled = YES;
    [menuView_down addSubview:pauseImage_down];
    
    [self.view addSubview:menuView_down];
    
    
    UIView *menuView_up = [[UIView alloc] initWithFrame:CGRectMake(0, halfWindowHeight, windowWidth, marginUp)];
    
    //set time label
    timeLabel_up = [[UILabel alloc] initWithFrame:CGRectMake(marginUp/2-20, marginUp/2-20, 100, 40)];
    timeLabel_up.backgroundColor = [UIColor clearColor];
    [timeLabel_up setText:timeString];
    [timeLabel_up setTextColor:[UIColor redColor]];
    [timeLabel_up setFont:[UIFont boldSystemFontOfSize:30]];
    //timeLabel_up.transform = CGAffineTransformMakeRotation(M_PI);
    [menuView_up addSubview:timeLabel_up];
    
    //add pause button
    UIImageView *pauseImage_up = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pause.png" ] highlightedImage:[UIImage imageNamed:@"pause_highligt.png" ]];
    [pauseImage_up setFrame:CGRectMake(windowWidth-100, 10, 80, 60)];
    pauseImage_up.userInteractionEnabled = YES;
    [menuView_up addSubview:pauseImage_up];
    
    [self.view addSubview:menuView_up];
    //change the rotation center , originally is (0.5,0.5)
    menuView_up.layer.anchorPoint= CGPointMake(0.5,-0.5); // which rotate the symmetrical view of down side
    menuView_up.backgroundColor = [UIColor grayColor];
    menuView_up.transform = CGAffineTransformMakeRotation(M_PI);
    
    //add tap gesture to pause image
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pauseImageClick)];
    [pauseImage_up addGestureRecognizer:singleTap];
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pauseImageClick)];
    [pauseImage_down addGestureRecognizer:singleTap1];
     
}

//image onclick function
-(void)pauseImageClick
{
    if (isPause)
    {
        [self resumeGame];
    }
    else
    {
        [self pauseGame];
    }
}

//do init for the upper buttons
-(void)initUpFlopButtons
{
    CGRect buttonFrame;
    buttons_up = [[NSMutableArray alloc] init];
    
    for (int i=0; i<rows; i++)
    {
        for (int j=0; j<cols; j++)
        {
            UIButton *currentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonFrame = CGRectMake(marginSides+(buttonMargin + buttonWidth)*j, marginUp + (buttonHeight + buttonMargin)*i, buttonWidth, buttonHeight);
            currentButton.frame = buttonFrame;
            [currentButton setImage:buttonImage_up forState:UIControlStateNormal];
            currentButton.contentMode = UIViewContentModeScaleAspectFit;
            //add touch event
            [currentButton addTarget:self action:@selector(upButtonTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
            //add currentButton to the buttons
            [buttons_up addObject:currentButton];
            [self.view addSubview:currentButton];
            currentButton.transform = CGAffineTransformMakeRotation(M_PI);
        }
        
    }
}

//do init for the down buttons
-(void)initDownFlopButtons
{
    CGRect buttonFrame;
    buttons_down = [[NSMutableArray alloc] init];
    
    for (int i=0; i<rows; i++)
    {
        for (int j=0; j<cols; j++)
        {
            UIButton *currentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonFrame = CGRectMake(marginSides+(buttonMargin + buttonWidth)*j, halfWindowHeight + marginUp + (buttonHeight + buttonMargin)*i, buttonWidth, buttonHeight);
            currentButton.frame = buttonFrame;
            [currentButton setImage:buttonImage_down forState:UIControlStateNormal];
            currentButton.contentMode = UIViewContentModeScaleAspectFit;
            //add touch event
            [currentButton addTarget:self action:@selector(downButtonTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
            //add currentButton to the buttons
            [buttons_down addObject:currentButton];
            [self.view addSubview:currentButton];
            
        }
        
    }
}

//the touch event of upper buttons
-(void)upButtonTouchEvent:(id)sender
{
    
    if (isUpTouchOK && sender != currentFlopped_up) {
        currentFlopped_up = [buttons_up objectAtIndex:[buttons_up indexOfObjectIdenticalTo:sender]];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:currentFlopped_up cache:NO];
        [currentFlopped_up setImage:[UIImage imageNamed:@"cardFruit.png" ] forState:UIControlStateNormal];
        [UIView commitAnimations];
        isUpTouchOK = NO;
    }

}

//the touch event of down buttons
-(void)downButtonTouchEvent:(id)sender
{
    if (isDownTouchOK && sender != currentFlopped_down) {
        currentFlopped_down = [buttons_down objectAtIndex:[buttons_down indexOfObjectIdenticalTo:sender]];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:currentFlopped_down cache:NO];
        [currentFlopped_down setImage:[UIImage imageNamed:@"cardCartoon.png" ] forState:UIControlStateNormal];
        [UIView commitAnimations];
        isDownTouchOK = NO;
    }
}

//fire the timer every interval
-(void)fireMainTimerTicker
{
    //if up button touch is no, which means there is a button being flopped
    if (isUpTouchOK == NO) {
        //automaticly flopping back the button after 20 intervals
        if (upDelayCount == 10)
        {
            [self refreshButton:YES];
            if (!isUpMatchFlag)
            {
                isUpTouchOK = YES;
            }
            upDelayCount = 0;
        }
        upDelayCount++;
    }
    
    //if down button touch is no, which means there is a button being flopped
    if (isDownTouchOK == NO) {
        //automaticly flopping back the button after 20 intervals
        if (downDelayCount == 10)
        {
            [self refreshButton:NO];
            if (!isDownMatchFlag)
            {
                [self refreshButton:NO];
                isDownTouchOK = YES;
            }
            downDelayCount = 0;
        }
        downDelayCount++;
    }
    //transfer the timer interval to seconds and minutes
    if(mil==10)
    {
        if(sec==59)
        {
            min+=1;
            sec=0;
            mil = 0;
        }
        else
        {
            sec+=1;
            mil=0;
        }
        
    }
    else
    {
        mil+=1;
    }
    
    timeString = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    [timeLabel_up setText:timeString];
    [timeLabel_down setText:timeString];
}


//refresh the button's image
-(void)refreshButton : (BOOL)isUpper
{
    if (isUpper) {
        if (isUpMatchFlag)
        {
            
        }
        else
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight+UIViewAnimationOptionCurveEaseInOut forView:currentFlopped_up cache:NO];
            [UIView commitAnimations];
            [currentFlopped_up setImage:[UIImage imageNamed:@"cardCartoon.png" ] forState:UIControlStateNormal];
            [self clearParameters:isUpper];
        }
        
    }
    else
    {
        if (isDownMatchFlag)
        {
            
        }
        else
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight+UIViewAnimationOptionCurveEaseInOut forView:currentFlopped_down cache:NO];
            [UIView commitAnimations];
            [currentFlopped_down setImage:[UIImage imageNamed:@"cardFruit.png" ] forState:UIControlStateNormal];
            [self clearParameters:isUpper];
        }

    }
    
}

//fade out the matched button
-(void)fadeOutButton : (BOOL)isUpper
{
    if (isUpper)
    {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//        [UIView setAnimationDuration:0.4];
        
    }
    [self clearParameters:isUpper];
}

//clear all parameters
-(void)clearParameters : (BOOL)isUpper
{
    if (isUpper) {
        isUpTouchOK = YES;
        isUpMatchFlag = NO;
        currentFlopped_up = Nil;
    }
    else
    {
        isDownTouchOK = YES;
        isDownMatchFlag = NO;
        currentFlopped_down = Nil;
    }
}

//clear all the buttons and images
-(void)clearAllButtons
{
    //clear upper buttons
    for (int i=0; i< [buttons_down count]; i++)
    {
        [(UIButton*)[buttons_up objectAtIndex:i] removeFromSuperview];
        [(UIButton*)[buttons_down objectAtIndex:i] removeFromSuperview];
    }
    buttons_up = [[NSMutableArray alloc] init];
    buttons_down = [[NSMutableArray alloc] init];
}

//start the timer
-(NSTimer*)startTimer
{
    NSTimer * timer;
    timer = [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(fireMainTimerTicker) userInfo:nil repeats:YES];
    return timer;
}
//pause the timer to stop
-(void)pauseTimer : (NSTimer*)timer
{
    [timer setFireDate:[NSDate distantFuture]];
}
//resume the timer to previous time
-(void)resumeTimer: (NSTimer*)timer
{
    [timer setFireDate:[NSDate distantPast]];
}
//stop the timer
-(void)stopTimer: (NSTimer*)timer
{
    [timer invalidate];
}

//start a new game
-(void)startNewGame
{
    mainTimer = [self startTimer];
}
//pause current game
-(void)pauseGame
{
    //[self clearAllButtons];
    [self pauseTimer : mainTimer];
    isPause = YES;
    NSLog(@"WOCACA");
}
//resume the game to play
-(void)resumeGame
{
    [self resumeTimer : mainTimer];
    isPause = NO;
}
//end the game, and return back to main menu
-(void)endGame
{
    [self stopTimer : mainTimer];
}


//draw line from beginPoint to endPoint
-(void)drawLine: (CGPoint)beginPoint : (CGPoint)endPoint
{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view  addSubview:imageView];
    //imageView.backgroundColor=[UIColor blueColor];
    //绘制一条白线
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0, 0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), beginPoint.x, beginPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), endPoint.x, endPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
