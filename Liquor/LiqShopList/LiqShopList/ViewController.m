//
//  ViewController.m
//  LiqShopList
//
//  Created by iMac Vasanth on 12/14/13.
//  Copyright (c) 2013 Thiruvengadam Krishnasamy. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // DB Data Retrieve and Save
    NSMutableArray *arr = [[NSMutableArray alloc] init];
     NSMutableDictionary *dic = [[NSMutableDictionary alloc]
     init];
     [dic setObject:@"Pondicherry" forKey:@"PickupAddr"];
     [dic setObject:@"Chennai" forKey:@"DestAddr"];
     [dic setObject:@"Pandeyan" forKey:@"Name"];
     [dic setObject:@"9003466343" forKey:@"Phone"];
     [dic setObject:@"pandeyan88@gmail.com" forKey:@"Email"];
     [dic setObject:@"12/13/2013" forKey:@"updatedDate"];
     
     [arr addObject:dic];
     
     [[DBManager getSharedInstance] functiontoImport_tblReserve:arr];
     
     
     NSMutableArray *arr2 = [[NSMutableArray alloc] init];
     arr2 = [[DBManager getSharedInstance] readInformationFromDatabase_tblReserve:@"tblReserve"];
     
     NSLog(@"Retrieved Values array ==> %@",arr2);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
