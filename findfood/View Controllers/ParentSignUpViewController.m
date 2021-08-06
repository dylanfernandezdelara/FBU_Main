//
//  ParentSignUpViewController.m
//  findfood
//
//  Created by dylanfdl on 7/12/21.
//

#import "ParentSignUpViewController.h"
#import "Parse/Parse.h"
#import <ChameleonFramework/Chameleon.h>

@interface ParentSignUpViewController ()
@property (weak, nonatomic) IBOutlet UIView *truckContainerView;
@property (weak, nonatomic) IBOutlet UIView *userContainerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation ParentSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.truckContainerView.alpha = 0.0;
    self.userContainerView.alpha = 1.0;
    
    PFUser *currUser = [PFUser currentUser];
    if ([currUser[@"userType"] isEqualToString:@"FoodTruck"]){
        self.segmentControl.selectedSegmentIndex = 1;
        [self.segmentControl sendActionsForControlEvents:UIControlEventValueChanged];
        self.segmentControl.alpha = 0.0;
    }
    

    self.segmentControl.selectedSegmentTintColor = [UIColor colorWithHexString:@"3B5B33"];
    self.segmentControl.backgroundColor = [UIColor colorWithHexString:@"B6D2AF"];
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName : [UIColor flatWhiteColor] };
    [self.segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
}

- (IBAction)didChangeIndex:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.userContainerView.alpha = 1.0;
            self.truckContainerView.alpha = 0.0;
            self.segmentControl.selectedSegmentTintColor = [UIColor colorWithHexString:@"3B5B33"];
            break;
        case 1:
            self.userContainerView.alpha = 0.0;
            self.truckContainerView.alpha = 1.0;
            self.segmentControl.selectedSegmentTintColor = [UIColor colorWithHexString:@"3B5B33"];
            break;
        default:
            break;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
