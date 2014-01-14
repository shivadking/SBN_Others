//
//  ViewController.m
//  DropDown
//
//  Created by Thiruvengadam Krishnasamy on 02/01/14.
//  Copyright (c) 2014 TWILIGHT SOFTWARES. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize txtField,DropView;

int flagView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    DropView.hidden=YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"\n fdf \ndfsad\nsdfsd\ndsfgsdf\ndsfa" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"1"@"2"@"3", nil];
    [self willPresentAlertView:alert];
    [alert show];
    
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    
    // add a new label and configure it to replace the title
    UILabel *tempTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,20,350, 20)];
    tempTitle.backgroundColor = [UIColor clearColor];
    tempTitle.textColor = [UIColor whiteColor];
    tempTitle.textAlignment = UITextAlignmentCenter;
    tempTitle.numberOfLines = 1;
    tempTitle.font = [UIFont boldSystemFontOfSize:18];
    tempTitle.text = alertView.title;
    alertView.title = @"";
    [alertView addSubview:tempTitle];
    
    // add another label to use as message
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 350, 200)];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.textAlignment = UITextAlignmentCenter;
    tempLabel.numberOfLines = 20;
    tempLabel.text = alertView.message;
    [alertView addSubview:tempLabel];
    
    // method used to resize the height of a label depending on the text height
    [self setUILabel:tempLabel withMaxFrame:CGRectMake(10,50, 350, 300) withText:alertView.message];
    alertView.message = @"";
    
    // set the frame of the alert view and center it
    alertView.frame = CGRectMake(CGRectGetMinX(alertView.frame) - (370 - CGRectGetWidth(alertView.frame))/2 ,
                                 alertView.frame.origin.y,
                                 370,
                                 tempLabel.frame.size.height + 120);
    
    
    // iterate through the subviews in order to find the button and resize it
    for( UIView *view in alertView.subviews)
    {
        if([[view class] isSubclassOfClass:[UIControl class]])
        {
            view.frame = CGRectMake   (view.frame.origin.x+2,
                                       tempLabel.frame.origin.y + tempLabel.frame.size.height + 10,
                                       370 - view.frame.origin.x *2-4,
                                       view.frame.size.height);
        }
    }
    
}
- (void)setUILabel:(UILabel *)myLabel withMaxFrame:(CGRect)maxFrame withText:(NSString *)theText{
    CGSize stringSize = [theText sizeWithFont:myLabel.font constrainedToSize:maxFrame.size lineBreakMode:myLabel.lineBreakMode];
    myLabel.frame = CGRectMake(myLabel.frame.origin.x,
                               myLabel.frame.origin.y,
                               myLabel.frame.size.width,
                               stringSize.height
                               );
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self touchField];
}

-(void)touchField
{
    DropView.hidden=NO;
    
    [txtField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void) textFieldDidChange:(UITextField*) txt
{
    if (txt.text.length>0)
    {
        DropView.hidden=YES;
    }
    else if(txt.text.length<=0)
    {
        DropView.hidden=NO;
    }

}

/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length>0)
    {
        DropView.hidden=YES;
        return YES;
    }
    else if(range.length<=0)
    {
        DropView.hidden=NO;
        return YES;
    }
    
    return YES;
}*/

-(BOOL)textFieldShouldReturn:(UITextField *)exit
{
    [exit resignFirstResponder];
    DropView.hidden=YES;
    return YES;
}

- (IBAction)btn1:(id)sender
{
    txtField.text=@"SJC";
    DropView.hidden=YES;
}

- (IBAction)btn2:(id)sender
{
    txtField.text=@"OAK";
    DropView.hidden=YES;
}

- (IBAction)btn3:(id)sender
{
    txtField.text=@"SFO";
    DropView.hidden=YES;
}
@end
