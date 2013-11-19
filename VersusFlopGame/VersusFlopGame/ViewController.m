//
//  ViewController.m
//  VersusFlopGame
//
//  Created by Haoero on 13-11-17.
//  Copyright (c) 2013年 Haoero. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //将page2设定成Storyboard Segue的目标UIViewController
    id page2 = segue.destinationViewController;
    
    //将值透过Storyboard Segue带给页面2的string变数

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
