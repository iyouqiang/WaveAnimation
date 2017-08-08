//
//  ViewController.m
//  YochiWaveAnimation
//
//  Created by Yochi·Kung on 2017/8/8.
//  Copyright © 2017年 Yochi. All rights reserved.
//

#import "ViewController.h"
#import "PKRWaveAnimation.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *img = [UIImage imageNamed:@"change-bg.png"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height-10, 1, 1, 1) resizingMode:UIImageResizingModeStretch];
    UIImageView *bgImgview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgview.image = img;
    [self.view addSubview:bgImgview];
    
    PKRWaveAnimation *waveView = [[PKRWaveAnimation alloc] initWithFrame:CGRectMake(0, 240, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 240)];
    [waveView loadWaveView:3 waveColors:nil opacity:0.8 amplitude:40 palstance:M_PI/CGRectGetWidth(self.view.frame) wavespeed:0.03 offsetY:0 isLaunchBubbles:NO];
    [self.view addSubview:waveView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
