//
//  FTruckHoursViewController.m
//  findfood
//
//  Created by dylanfdl on 7/16/21.
//

#import "FTruckHoursViewController.h"

@interface FTruckHoursViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@property (weak, nonatomic) IBOutlet UILabel *dailyLabel;
@property (weak, nonatomic) IBOutlet UILabel *customHoursLabel;

@property (weak, nonatomic) IBOutlet UILabel *dailyOpen;
@property (weak, nonatomic) IBOutlet UIDatePicker *dailyOpenContents;
@property (weak, nonatomic) IBOutlet UILabel *dailyClose;
@property (weak, nonatomic) IBOutlet UIDatePicker *dailyCloseContents;

@property (weak, nonatomic) IBOutlet UILabel *sunLabel;
@property (weak, nonatomic) IBOutlet UILabel *monLabel;
@property (weak, nonatomic) IBOutlet UILabel *tueLabel;
@property (weak, nonatomic) IBOutlet UILabel *wedLabel;
@property (weak, nonatomic) IBOutlet UILabel *thuLabel;
@property (weak, nonatomic) IBOutlet UILabel *friLabel;
@property (weak, nonatomic) IBOutlet UILabel *satLabel;
@property (weak, nonatomic) IBOutlet UILabel *customOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *customCloseLabel;

@property (weak, nonatomic) IBOutlet UIDatePicker *sunOpenTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *monOpenTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *tueOpenTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *wedOpenTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *thuOpenTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *friOpenTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *satOpenTime;

@property (weak, nonatomic) IBOutlet UIDatePicker *sunCloseTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *monCloseTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *tueCloseTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *wedCloseTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *thuCloseTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *friCloseTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *satCloseTime;



@end

@implementation FTruckHoursViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.monLabel.alpha = 0;
}

- (IBAction)switchFlipped:(UISwitch *)sender {
    if (sender.on){
        self.dailyOpen.alpha = 1;
        self.dailyOpenContents.alpha = 1;
        self.dailyClose.alpha = 1;
        self.dailyCloseContents.alpha = 1;
        [self.customHoursLabel setFont:[UIFont systemFontOfSize:17]];
        [self.dailyLabel setFont:[UIFont boldSystemFontOfSize:17]];
        
        self.customOpenLabel.alpha = 0;
        self.customCloseLabel.alpha = 0;
        
        self.sunLabel.alpha = 0;
        self.monLabel.alpha = 0;
        self.tueLabel.alpha = 0;
        self.wedLabel.alpha = 0;
        self.thuLabel.alpha = 0;
        self.friLabel.alpha = 0;
        self.satLabel.alpha = 0;
        
        self.sunOpenTime.alpha = 0;
        self.monOpenTime.alpha = 0;
        self.tueOpenTime.alpha = 0;
        self.wedOpenTime.alpha = 0;
        self.thuOpenTime.alpha = 0;
        self.friOpenTime.alpha = 0;
        self.satOpenTime.alpha = 0;
        
        self.sunCloseTime.alpha = 0;
        self.monCloseTime.alpha = 0;
        self.tueCloseTime.alpha = 0;
        self.wedCloseTime.alpha = 0;
        self.thuCloseTime.alpha = 0;
        self.friCloseTime.alpha = 0;
        self.satCloseTime.alpha = 0;

    }
    else {
        self.dailyOpen.alpha = 0;
        self.dailyOpenContents.alpha = 0;
        self.dailyClose.alpha = 0;
        self.dailyCloseContents.alpha = 0;
        [self.dailyLabel setFont:[UIFont systemFontOfSize:17]];
        [self.customHoursLabel setFont:[UIFont boldSystemFontOfSize:17]];
        
        self.customOpenLabel.alpha = 1;
        self.customCloseLabel.alpha = 1;
        
        self.sunLabel.alpha = 1;
        self.monLabel.alpha = 1;
        self.tueLabel.alpha = 1;
        self.wedLabel.alpha = 1;
        self.thuLabel.alpha = 1;
        self.friLabel.alpha = 1;
        self.satLabel.alpha = 1;
        
        self.sunOpenTime.alpha = 1;
        self.monOpenTime.alpha = 1;
        self.tueOpenTime.alpha = 1;
        self.wedOpenTime.alpha = 1;
        self.thuOpenTime.alpha = 1;
        self.friOpenTime.alpha = 1;
        self.satOpenTime.alpha = 1;
        
        self.sunCloseTime.alpha = 1;
        self.monCloseTime.alpha = 1;
        self.tueCloseTime.alpha = 1;
        self.wedCloseTime.alpha = 1;
        self.thuCloseTime.alpha = 1;
        self.friCloseTime.alpha = 1;
        self.satCloseTime.alpha = 1;
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
