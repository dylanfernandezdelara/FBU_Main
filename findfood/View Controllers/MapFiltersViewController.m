//
//  MapFiltersViewController.m
//  findfood
//
//  Created by dylanfdl on 7/22/21.
//

#import "MapFiltersViewController.h"
#import "UserMapViewController.h"

@interface MapFiltersViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *pizzaFilter;
@property (weak, nonatomic) IBOutlet UISwitch *bbqFilter;
@property (weak, nonatomic) IBOutlet UISwitch *brunchFilter;
@property (weak, nonatomic) IBOutlet UISwitch *mexicanFilter;
@property (weak, nonatomic) IBOutlet UISwitch *seafoodFilter;
@property (weak, nonatomic) IBOutlet UISwitch *sandwichesFilter;

@property (weak, nonatomic) IBOutlet UISwitch *popularFilter;

@property (weak, nonatomic) IBOutlet UISegmentedControl *priceRangeSegment;

@end

@implementation MapFiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
}


@end
