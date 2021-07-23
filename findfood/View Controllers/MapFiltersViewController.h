//
//  MapFiltersViewController.h
//  findfood
//
//  Created by dylanfdl on 7/22/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapFiltersViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *arrayOfFilters;
@property (strong, nonatomic) NSMutableArray *formerFoodTrucks;
@property (strong, nonatomic) NSMutableArray *formerTruckAnnotations;

@end

NS_ASSUME_NONNULL_END
