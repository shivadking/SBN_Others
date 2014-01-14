//
//  SubViewViewController.h
//  testing
//
//  Created by Thiruvengadam Krishnasamy on 29/11/13.
//  Copyright (c) 2013 TWILIGHT SOFTWARES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubViewViewController : UIViewController<UITableViewDelegate>
{
    NSMutableArray *loadData;
}
@property (weak) id parentController;
@property (strong, nonatomic) IBOutlet UITableView *subTableView;

@end
