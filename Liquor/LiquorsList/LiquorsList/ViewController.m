//
//  ViewController.m
//  LiquorsList
//
//  Created by Thiruvengadam Krishnasamy on 16/12/13.
//  Copyright (c) 2013 TWILIGHT SOFTWARES. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.\
    
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]
                                init];
    [dic setObject:@"name" forKey:@"name"];
    [dic setObject:@"address" forKey:@"address"];
    [dic setObject:@"phone" forKey:@"phone"];
   
    [arr addObject:dic];
        
    [[DBManager getSharedInstance] functiontoImport_tblReserve:arr];
        
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    arr2 = [[DBManager getSharedInstance] readInformationFromDatabase_tblReserve:@"tblLiquorsShopList"];
    
    NSLog(@"Retrieved Values array ==> %@",arr2);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
