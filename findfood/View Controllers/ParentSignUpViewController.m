//
//  ParentSignUpViewController.m
//  findfood
//
//  Created by dylanfdl on 7/12/21.
//

#import "ParentSignUpViewController.h"

@interface ParentSignUpViewController ()
@property (weak, nonatomic) IBOutlet UIView *truckContainerView;
@property (weak, nonatomic) IBOutlet UIView *userContainerView;

@end

@implementation ParentSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.truckContainerView.alpha = 0.0;
    self.userContainerView.alpha = 1.0;
}

- (IBAction)didChangeIndex:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.userContainerView.alpha = 1.0;
            self.truckContainerView.alpha = 0.0;
            break;
        case 1:
            self.userContainerView.alpha = 0.0;
            self.truckContainerView.alpha = 1.0;
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
