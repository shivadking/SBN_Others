//
//  ViewController.h
//  DropDown
//
//  Created by Thiruvengadam Krishnasamy on 02/01/14.
//  Copyright (c) 2014 TWILIGHT SOFTWARES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtField;
@property (strong, nonatomic) IBOutlet UIView *DropView;

- (IBAction)btn1:(id)sender;
- (IBAction)btn2:(id)sender;
- (IBAction)btn3:(id)sender;

@end
