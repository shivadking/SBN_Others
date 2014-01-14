//
//  ViewController.m
//  testing
//
//  Created by Thiruvengadam Krishnasamy on 21/11/13.
//  Copyright (c) 2013 TWILIGHT SOFTWARES. All rights reserved.
//

#import "ViewController.h"
#import "SubViewViewController.h"


@interface ViewController ()

@end

@implementation ViewController

SubViewViewController *viewDropDown;

NSString *const BaseURLString = @"http://192.168.0.127:92/api/LoginApi/";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /*UIGestureRecognizer *touchTxt = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(touched)];
    [_txtDropDown addGestureRecognizer:touchTxt];*/
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touched)];
    [_txtDropDown addGestureRecognizer:tapGesture];
    
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touched2)];
    [_txtDropDown2 addGestureRecognizer:tapGesture];
    
    //[_txtDropDown addTarget:self action:@selector(touched) forControlEvents:UIControlEventEditingDidBegin];
    

}

-(void) touched
{
    NSLog(@"Touches");
    CGRect frames = _txtDropDown.frame;
    UIView *viewDropDown = [[UIView alloc] initWithFrame:CGRectMake(frames.origin.x, frames.origin.y+30, frames.size.width, 300)];
    viewDropDown.backgroundColor = [UIColor greenColor];
    viewDropDown.alpha=0;
    [self.view addSubview:viewDropDown];
    [UIView animateWithDuration:1.5 animations:^{
        viewDropDown.alpha = 1;
    }];
    
    
}

-(void) touched2
{
    NSLog(@"Touches");
    CGRect frames = _txtDropDown2.frame;
    
    viewDropDown = [self.storyboard instantiateViewControllerWithIdentifier:@"SubViewViewController"];
 
    
    //UIView *viewDropDown = [[UIView alloc] initWithFrame:CGRectMake(frames.origin.x, frames.origin.y+30, frames.size.width, 300)];
    viewDropDown.view.frame = CGRectMake(frames.origin.x, frames.origin.y+30, frames.size.width, 200);
    //viewDropDown.view.backgroundColor = [UIColor greenColor];
    viewDropDown.view.alpha=0;
    viewDropDown.parentController = self;
    [self.view addSubview:viewDropDown.view];
    [UIView animateWithDuration:1.5 animations:^{
        viewDropDown.view.alpha = 1;
    }];
    
    
}

-(void) removeViews2
{
    [viewDropDown.view removeFromSuperview];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPost:(id)sender {
    
    NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:BaseURLString]];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"raja",@"123456", nil] forKeys:[NSArray arrayWithObjects:@"UserName",@"password", nil]];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    [client postPath:@"Login"
          parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"Resonse = %@",responseObject);

             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                              message:[NSString stringWithFormat:@"%@",error]
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [av show];
                 
             }
     ];
}

- (IBAction)btnGet:(id)sender {
    
    NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:BaseURLString]];
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:@"json" forKey:@"format"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    [client getPath:@"weather.php"
         parameters:parameters
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                //self.title = @"HTTP GET";
                //[self.tableView reloadData];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                             message:[NSString stringWithFormat:@"%@",error]
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
                
            }
     ];
}
@end
