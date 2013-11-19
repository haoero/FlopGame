//
//  SingleGameViewController.h
//  VersusFlopGame
//
//  Created by Haoero on 13-11-17.
//  Copyright (c) 2013年 Haoero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleGameViewController : UIViewController
{
    float halfWindowHeight, windowWidth;
    float buttonHeight, buttonWidth, buttonMargin;
    float marginUp, marginSides;
    UIImage *buttonImage_up, *buttonImage_down, *shadowView_up, *shadowView_down;
    NSMutableArray *buttons_up,*buttons_down;
    id currentFlopped_up, currentFlopped_down;
    int rows, cols;
    BOOL isUpTouchOK, isDownTouchOK, isUpMatchFlag, isDownMatchFlag, isPause;
    
    //Timer to calculate time
    NSTimer *mainTimer;
    int mil, sec, min, upDelayCount, downDelayCount, upMatchCount, downMatchCount;
    UILabel *timeLabel_up,*timeLabel_down;
    NSString *timeString;
}
@end
