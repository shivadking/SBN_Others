//
//  ViewController.h
//  testing
//
//  Created by Thiruvengadam Krishnasamy on 21/11/13.
//  Copyright (c) 2013 TWILIGHT SOFTWARES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
- (IBAction)btnPost:(id)sender;
- (IBAction)btnGet:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtDropDown;
@property (strong, nonatomic) IBOutlet UITextField *txtDropDown2;
-(void) removeViews2;
@end
