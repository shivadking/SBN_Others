//
//  ViewController.m
//  scrollView
//
//  Created by Thiruvengadam Krishnasamy on 31/12/13.
//  Copyright (c) 2013 TWILIGHT SOFTWARES. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.scrollViews.contentSize = CGSizeMake(960, 200);
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"download.jpeg"]];
    [self.scrollViews addSubview:imageView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
