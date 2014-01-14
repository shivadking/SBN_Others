//
//  CustomCell.h
//  LiqShopList
//
//  Created by iMac Vasanth on 12/14/13.
//  Copyright (c) 2013 Thiruvengadam Krishnasamy. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *address;

@property (strong, nonatomic) IBOutlet UITextField *phone;



@end
