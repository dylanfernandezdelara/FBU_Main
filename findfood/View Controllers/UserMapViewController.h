//
//  UserMapViewController.h
//  findfood
//
//  Created by dylanfdl on 7/13/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserMapViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *filterArguments;
@property (strong, nonatomic) NSMutableArray *arrayOfFoodTrucks;
@property (strong, nonatomic) NSMutableArray *arrayOfAnnotations;
@property (strong, nonatomic) NSMutableDictionary *dictOfFoodTrucks;

@end

NS_ASSUME_NONNULL_END
