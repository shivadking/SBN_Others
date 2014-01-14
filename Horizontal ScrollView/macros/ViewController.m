//
//  ViewController.m
//  macros
//
//  Created by Thiruvengadam Krishnasamy on 06/01/14.
//  Copyright (c) 2014 TWILIGHT SOFTWARES. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //#undef MESSAGE
 
    [self setupHorizontalScrollView];
}

-(NSMutableArray*) dateArray
{
    NSMutableArray *dtArr = [[NSMutableArray alloc] init];
    
    NSDate *now = [NSDate date];
    //[now dateByAddingTimeInterval:-7*24*60*60];
    for(int i=10; i>=0; i--)
    {
        int daysToSubtract = i;
        NSDate *newDate1 = [now dateByAddingTimeInterval:-daysToSubtract*24*60*60];
        //NSLog(@"daysToSubtractnewDate => %@",newDate1);
        
        [dtArr addObject:[self dateFormating:newDate1]];
        
    }
    [dtArr addObject:[self dateFormating:now]];
    for(int i=1; i<=10; i++)
    {
        int daysToAdd = i;
        NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
       // NSLog(@"newDate => %@",newDate1);
        
        [dtArr addObject:[self dateFormating:newDate1]];
        
        
    }
    
    
    
    return dtArr;
    
}

-(NSString*) dateFormating:(NSDate*) now
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *theDate = [dateFormat stringFromDate:now];
    
    return theDate;
}

- (void)setupHorizontalScrollView
{
    NSMutableArray *dtArr = [[NSMutableArray alloc] init];
    dtArr = [self dateArray];
    scrollView.delegate = self;
    
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    [scrollView setCanCancelContentTouches:NO];
    
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollView.clipsToBounds = NO;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    
    CGFloat cx = 0;

    
    for(int i=0; i<[dtArr count]; i++)
    {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor redColor]];
        [btn setTitle:[dtArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAc:) forControlEvents:UIControlEventTouchDown];
        [btn setTag:i];
        
        CGRect rect = btn.frame;
        rect.size.height = 40;
        rect.size.width = 140;
        rect.origin.x = cx;
        rect.origin.y = 0;
        btn.frame =rect;
        
        [scrollView addSubview:btn];
        
        NSLog(@"name => %@, frame => %f,%f",[dtArr objectAtIndex:i],rect.origin.x,rect.origin.y);
        
        cx += btn.frame.size.width+5;
    }
    
    //self.pageControl.numberOfPages = nimages;

    [scrollView setContentSize:CGSizeMake(cx, [scrollView bounds].size.height)];
    
    CGFloat newContentOffsetX = (scrollView.contentSize.width - scrollView.frame.size.width) / 2;
    NSLog(@"size => %f",newContentOffsetX);
    scrollView.contentOffset = CGPointMake(newContentOffsetX, 0);
    
    //[scrollView scrollRectToVisible:CGRectMake(1450, 0, 140, 40) animated:YES];
}

-(void) btnAc:(UIButton*) btnName
{
    NSLog(@"Id => %d",btnName.tag);
    
    NSLog(@"Names => %@",btnName.titleLabel.text);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
