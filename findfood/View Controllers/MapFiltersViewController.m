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
    
    self.pizzaFilter.on = [self.arrayOfFilters[0] boolValue];
    self.bbqFilter.on = [self.arrayOfFilters[1] boolValue];
    self.brunchFilter.on = [self.arrayOfFilters[2] boolValue];
    self.mexicanFilter.on = [self.arrayOfFilters[3] boolValue];
    self.seafoodFilter.on = [self.arrayOfFilters[4] boolValue];
    self.sandwichesFilter.on = [self.arrayOfFilters[5] boolValue];
    
    if ([self.arrayOfFilters[6] intValue] != 2){
        self.popularFilter.on = [self.arrayOfFilters[6] boolValue];
    }
    
    if ([self.arrayOfFilters[7] intValue] != 2){
        self.priceRangeSegment.selectedSegmentIndex = [self.arrayOfFilters[7] intValue];
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // NSLog(@"%@", [NSNumber numberWithBool:self.pizzaFilter.on]);
    self.arrayOfFilters[0] = [NSNumber numberWithBool:self.pizzaFilter.on];
    // NSLog(@"SHOULD HAVE PIZZA AS 1: %@", self.arrayOfFilters);
    self.arrayOfFilters[1] = [NSNumber numberWithBool:self.bbqFilter.on];
    self.arrayOfFilters[2] = [NSNumber numberWithBool:self.brunchFilter.on];
    self.arrayOfFilters[3] = [NSNumber numberWithBool:self.mexicanFilter.on];
    self.arrayOfFilters[4] = [NSNumber numberWithBool:self.seafoodFilter.on];
    self.arrayOfFilters[5] = [NSNumber numberWithBool:self.sandwichesFilter.on];
    
    self.arrayOfFilters[6] = [NSNumber numberWithBool:self.popularFilter.on];
    
    self.arrayOfFilters[7] = [NSNumber numberWithInteger:self.priceRangeSegment.selectedSegmentIndex];
    
    if ([segue.identifier isEqualToString:@"applyFiltersSegue"]){

        UserMapViewController *userMapView = [segue destinationViewController];
        userMapView.filterArguments = self.arrayOfFilters;
        userMapView.arrayOfFoodTrucks = self.formerFoodTrucks;
        userMapView.arrayOfAnnotations = self.formerTruckAnnotations;
        
    }
    
}


@end
