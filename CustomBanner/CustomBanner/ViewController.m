//
//  ViewController.m
//  CustomBanner
//
//  Created by Kity_Pei on 16/6/2.
//  Copyright © 2016年 Kity_Pei. All rights reserved.
//

#import "ViewController.h"
#import "CustomBannerView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CustomBannerView *customView = [[CustomBannerView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 300) andImageList:@[@"01.jpg",@"02.jpg"] withPageControlLocation:LocationAtCenter];
//    customView.autoScroll = YES;
    
    customView.backgroundColor = [UIColor redColor];
    [self.view addSubview:customView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
