//
//  ViewController.m
//  FLSlideView
//
//  Created by clarence on 16/12/22.
//  Copyright © 2016年 gitKong. All rights reserved.
//

#import "ViewController.h"
#import "UIView+drag.h"
#import "FLView.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()

@property (nonatomic,weak)UIView *firstView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer * playerLayer;
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
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    view2.backgroundColor = [UIColor redColor];
    
    
    view2.fl_canSlide = YES;
    view2.fl_bounces = NO;
    view2.fl_isAdsorb = YES;
    [view1 addSubview:view2];
    
    
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"]];
    [self.player play];
    self.player.usesExternalPlaybackWhileExternalScreenIsActive=YES;
    self.playerLayer=[[AVPlayerLayer alloc]init];
    self.playerLayer.backgroundColor=[UIColor blackColor].CGColor;
    self.playerLayer.player=self.player;
    self.playerLayer.frame=view2.bounds;
    [self.playerLayer displayIfNeeded];
    [view2.layer insertSublayer:self.playerLayer atIndex:0];
    self.playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
    
    FLView *view3 = [[FLView alloc] initWithFrame:CGRectMake(250, 0, 50, 50)];
    view3.backgroundColor = [UIColor greenColor];
    
    view3.fl_canSlide = YES;
    view3.fl_bounces = YES;
    view3.fl_isAdsorb = YES;
    [view1 addSubview:view3];
    
}


@end
