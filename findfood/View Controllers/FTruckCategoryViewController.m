//
//  FTruckCategoryViewController.m
//  findfood
//
//  Created by dylanfdl on 7/20/21.
//

#import "FTruckCategoryViewController.h"
#import "Parse/Parse.h"

@interface FTruckCategoryViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *pizzaSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *bbqSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *brunchSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *mexicanSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *seafoodSwith;
@property (weak, nonatomic) IBOutlet UISwitch *sandwichesSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priceControl;

@end

@implementation FTruckCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *currUser = [PFUser currentUser];
    
    if (currUser[@"pizzaType"] != nil && currUser[@"bbqType"] != nil && currUser[@"brunchType"] != nil && currUser[@"mexicanType"] != nil && currUser[@"seafoodType"] != nil && currUser[@"sandwichesType"] != nil && currUser[@"priceLevel"] != nil){
        
        self.pizzaSwitch.on = currUser[@"pizzaType"];
        self.bbqSwitch.on = currUser[@"bbqType"];
        self.brunchSwitch.on = currUser[@"brunchType"];
        self.mexicanSwitch.on = currUser[@"mexicanType"];
        self.seafoodSwith.on = currUser[@"seafoodType"];
        self.sandwichesSwitch.on = currUser[@"sandwichesType"];
        
        self.priceControl.selectedSegmentIndex = [currUser[@"priceLevel"] integerValue];
    
    }
}

- (IBAction)saveNow:(UIButton *)sender {
    PFUser *currUser = [PFUser currentUser];
    
    currUser[@"pizzaType"] = [NSNumber numberWithBool:self.pizzaSwitch.on];
    currUser[@"bbqType"] = [NSNumber numberWithBool:self.bbqSwitch.on];
    currUser[@"brunchType"] = [NSNumber numberWithBool:self.brunchSwitch.on];
    currUser[@"mexicanType"] = [NSNumber numberWithBool:self.mexicanSwitch.on];
    currUser[@"seafoodType"] = [NSNumber numberWithBool:self.seafoodSwith.on];
    currUser[@"sandwichesType"] = [NSNumber numberWithBool:self.sandwichesSwitch.on];
    
    currUser[@"priceLevel"] = [NSNumber numberWithInt:self.priceControl.selectedSegmentIndex];

    [[PFUser currentUser] saveInBackground];
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
