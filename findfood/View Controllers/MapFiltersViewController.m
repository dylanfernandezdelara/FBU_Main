//
//  MapFiltersViewController.m
//  findfood
//
//  Created by dylanfdl on 7/22/21.
//

#import "MapFiltersViewController.h"
#import "UserMapViewController.h"
#import "LUNSegmentedControl.h"

@interface MapFiltersViewController ()<LUNSegmentedControlDataSource, LUNSegmentedControlDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *pizzaFilter;
@property (weak, nonatomic) IBOutlet UISwitch *bbqFilter;
@property (weak, nonatomic) IBOutlet UISwitch *brunchFilter;
@property (weak, nonatomic) IBOutlet UISwitch *mexicanFilter;
@property (weak, nonatomic) IBOutlet UISwitch *seafoodFilter;
@property (weak, nonatomic) IBOutlet UISwitch *sandwichesFilter;

@property (weak, nonatomic) IBOutlet UISwitch *popularFilter;

@property (weak, nonatomic) IBOutlet UISegmentedControl *priceRangeSegment;

@property (weak, nonatomic) IBOutlet LUNSegmentedControl *priceRangeFilter;

@end

@implementation MapFiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

// Attempt at getting an objective c library to work

//self.priceRangeFilter.transitionStyle = LUNSegmentedControlTransitionStyleFade;
//
//- (NSInteger)numberOfStatesInSegmentedControl:(LUNSegmentedControl *)segmentedControl {
//    return 3;
//}
//
//- (NSArray<UIColor *> *)segmentedControl:(LUNSegmentedControl *)segmentedControl gradientColorsForStateAtIndex:(NSInteger)index {
//    switch (index) {
//        case 0:
//            return @[[UIColor colorWithRed:160 / 255.0 green:223 / 255.0 blue:56 / 255.0 alpha:1.0], [UIColor colorWithRed:177 / 255.0 green:255 / 255.0 blue:0 / 255.0 alpha:1.0]];
//
//            break;
//
//        case 1:
//            return @[[UIColor colorWithRed:78 / 255.0 green:252 / 255.0 blue:208 / 255.0 alpha:1.0], [UIColor colorWithRed:51 / 255.0 green:199 / 255.0 blue:244 / 255.0 alpha:1.0]];
//            break;
//
//        case 2:
//            return @[[UIColor colorWithRed:178 / 255.0 green:0 / 255.0 blue:235 / 255.0 alpha:1.0], [UIColor colorWithRed:233 / 255.0 green:0 / 255.0 blue:147 / 255.0 alpha:1.0]];
//            break;
//
//        default:
//            break;
//    }
//    return nil;
//}
//
//- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForStateAtIndex:(NSInteger)index {
//    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%lu",(long)index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16]}];
//}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
}


@end
