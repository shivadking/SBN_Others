#import <UIKit/UIKit.h>

@interface TEST_DRAW_APPViewController : UIViewController {
	CGPoint lastPoint;
	UIImageView *drawImage;
	BOOL mouseSwiped;	
	int mouseMoved;
}
@property (retain, nonatomic) IBOutlet UIImageView *imgSignature;
- (IBAction)btnDraw:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *lblBtnSign;

@end

