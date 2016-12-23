//
//  ViewController.m
//  FLSlideView
//
//  Created by clarence on 16/12/22.
//  Copyright © 2016年 gitKong. All rights reserved.
//

#import "ViewController.h"
#import "UIView+drag.h"
@interface ViewController ()

@property (nonatomic,weak)UIView *firstView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"gitkong";
    self.view.backgroundColor = [UIColor redColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
    view.backgroundColor = [UIColor grayColor];
    view.fl_isAdsorb = NO;
    view.fl_bounces = YES;
    view.fl_canSlide = YES;
    
    
    self.firstView = view;
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [view addSubview:slider];
    [self.view addSubview:view];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    view1.center = self.view.center;
    NSLog(@"vc = %.2lf",view1.frame.origin.x);
    view1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    view2.backgroundColor = [UIColor redColor];
    
    view2.fl_canSlide = YES;
    view2.fl_bounces = NO;
    view2.fl_isAdsorb = YES;
    [view1 addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(250, 0, 50, 50)];
    view3.backgroundColor = [UIColor greenColor];
    
    view3.fl_canSlide = YES;
    view3.fl_bounces = YES;
    view3.fl_isAdsorb = YES;
    [view1 addSubview:view3];
    
}


@end
