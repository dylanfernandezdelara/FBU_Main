//
//  UserMapViewController.m
//  findfood
//
//  Created by dylanfdl on 7/13/21.
//

#import "Mapkit/Mapkit.h"
#import <CoreLocation/CoreLocation.h>
#import "UserMapViewController.h"
#import "Parse/Parse.h"
#import "MapFiltersViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define EARTHCIRUMFERENCE 40075000

@interface UserMapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic)  CLLocationManager *locationManager;
//@property (strong, nonatomic) NSArray *arrayOfFoodTrucks;

@property(assign, nonatomic) BOOL pizzaFilter;
@property(assign, nonatomic) BOOL bbqFilter;
@property(assign, nonatomic) BOOL brunchFilter;
@property(assign, nonatomic) BOOL mexicanFilter;
@property(assign, nonatomic) BOOL seafoodFilter;
@property(assign, nonatomic) BOOL sandwichesFilter;

@property(assign, nonatomic) BOOL popularFilter;

@property(assign, nonatomic) NSInteger priceFilter;

@end

@implementation UserMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    UIPanGestureRecognizer* dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(isMapDoneMoving:)];
        [dragRecognizer setDelegate:self];
        [self.mapView addGestureRecognizer:dragRecognizer];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
             [self.locationManager requestWhenInUseAuthorization];
         }
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    
    [self.mapView setCenterCoordinate:self.locationManager.location.coordinate animated:true];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 400, 400);
    [self.mapView setRegion:region];
    
    // NSLog(@"FILTER COUNT: %lu", self.filterArguments.count);
    if (self.filterArguments.count != 8){
        NSMutableArray *initArrOfAnnotations = [[NSMutableArray alloc] init];
        NSMutableArray *initArrOfTrucks = [[NSMutableArray alloc] init];
        self.arrayOfAnnotations = initArrOfAnnotations;
        self.arrayOfFoodTrucks = initArrOfTrucks;
        
        //NSLog(@"shouldn't be here");
        self.pizzaFilter = false;
        self.bbqFilter = false;
        self.brunchFilter = false;
        self.mexicanFilter = false;
        self.seafoodFilter = false;
        self.sandwichesFilter = false;
        
        NSMutableArray *defaultArguments = [[NSMutableArray alloc] init];
        [defaultArguments addObject:[NSNumber numberWithBool:self.pizzaFilter]];
        [defaultArguments addObject:[NSNumber numberWithBool:self.bbqFilter]];
        [defaultArguments addObject:[NSNumber numberWithBool:self.brunchFilter]];
        [defaultArguments addObject:[NSNumber numberWithBool:self.mexicanFilter]];
        [defaultArguments addObject:[NSNumber numberWithBool:self.seafoodFilter]];
        [defaultArguments addObject:[NSNumber numberWithBool:self.sandwichesFilter]];
        
        // temp placeholders for popular and price filter
        [defaultArguments addObject:[NSNumber numberWithInteger:2]];
        [defaultArguments addObject:[NSNumber numberWithInteger:2]];
        
        self.filterArguments = defaultArguments;
    }
    else {
        [self.mapView addAnnotations:self.arrayOfAnnotations];
    }
    
    NSLog(@"FILTER ARRAY: %@", self.filterArguments);
    
    [self fetchFoodTrucks:self.filterArguments];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)isMapDoneMoving:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        [self fetchFoodTrucks:self.filterArguments];
        NSLog(@"Map moved");
    }
}

- (void)addAnnotationsToMap {
    for (int i=0; i<self.arrayOfFoodTrucks.count; i++) {
        MKPointAnnotation* annotation= [MKPointAnnotation new];
        PFUser *tempTruck = self.arrayOfFoodTrucks[i];
        PFGeoPoint *temp = tempTruck[@"truckLocation"];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(temp.latitude, temp.longitude);
        annotation.coordinate = coord;
        annotation.title = tempTruck[@"fullName"];
        [self.mapView addAnnotation:annotation];
        [self.arrayOfAnnotations addObject:annotation];
    }
}

- (NSMutableArray*)removeDuplicateTrucks:(NSArray*)smallerArr removeFrom:(NSMutableArray*)biggerArr{
    
    NSMutableDictionary *objectIDtoTruck = [[NSMutableDictionary alloc] init];
    NSMutableArray *resultedTrucks = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < smallerArr.count; i++){
        PFUser *currTruck = smallerArr[i];
        [objectIDtoTruck setObject:currTruck forKey:currTruck.objectId];
    }
    
    for (int i = 0; i < biggerArr.count; i++){
        PFUser *currTruck = biggerArr[i];
        if ( ![objectIDtoTruck objectForKey:currTruck.objectId] ){
            [resultedTrucks addObject:biggerArr[i]];
        }
    }
    
    return resultedTrucks;
    
}

- (NSMutableArray*)convertRemovedTruckObjectsToAnnotation:(NSMutableArray*)FoodTrucks {
    NSMutableArray* convertedToAnnotations = [[NSMutableArray alloc] init];
    for (int i=0; i<FoodTrucks.count; i++) {
        MKPointAnnotation* annotation= [MKPointAnnotation new];
        PFUser *tempTruck = FoodTrucks[i];
        PFGeoPoint *temp = tempTruck[@"truckLocation"];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(temp.latitude, temp.longitude);
        annotation.coordinate = coord;
        annotation.title = tempTruck[@"fullName"];
        [convertedToAnnotations addObject:annotation];
    }
    return convertedToAnnotations;
}

- (MKMarkerAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation.title isEqualToString:@"My Location"]){
        return nil;
    }
    
     MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MKMarkerAnnotationView"];
     
    if (annotationView == nil) {
         annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKMarkerAnnotationView"];
         annotationView.clusteringIdentifier = @"MKMarkerAnnotationView";
     }
    
     annotationView.markerTintColor = UIColorFromRGB(0x3B5B33);
     annotationView.glyphImage = [UIImage imageNamed:@"truckMarker"];
    
     return annotationView;
 }

- (void)fetchFoodTrucks:(NSArray*)filters {
    PFQuery *UserQuery = [PFUser query];
    // [UserQuery fromLocalDatastore];
    
//    // 360 degress, 400m to edge of region
//    double degreeChangeFromCenter = 360 * 400 / EARTHCIRUMFERENCE;
//
//    // moving west increases long, moving south increases lat
//    PFGeoPoint *southwestCorner = [PFGeoPoint geoPointWithLatitude:self.mapView.centerCoordinate.latitude + degreeChangeFromCenter longitude:self.mapView.centerCoordinate.longitude + degreeChangeFromCenter];
//
//    PFGeoPoint *northwestCorner = [PFGeoPoint geoPointWithLatitude:self.mapView.centerCoordinate.latitude - degreeChangeFromCenter longitude:self.mapView.centerCoordinate.longitude - degreeChangeFromCenter];
//
//    [UserQuery whereKey:@"truckLocation" withinGeoBoxFromSouthwest:southwestCorner toNortheast:northwestCorner];
    
    NSNumber *trueValue = [NSNumber numberWithBool:true];
    
    // NSLog(@"INDEX 0: %@", [filters objectAtIndex:0]);
    if ([filters objectAtIndex:0] == trueValue){
        //NSLog(@"INSIDE PIZZA KEY");
        [UserQuery whereKey:@"pizzaType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:1] == trueValue){
        [UserQuery whereKey:@"bbqType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:2] == trueValue){
        [UserQuery whereKey:@"brunchType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:3] == trueValue){
        [UserQuery whereKey:@"mexicanType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:4] == trueValue){
        [UserQuery whereKey:@"seafoodType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:5] == trueValue){
        [UserQuery whereKey:@"sandwichesType" equalTo:trueValue];
    }
    
    [UserQuery whereKey:@"userType" equalTo:@"FoodTruck"];
    [UserQuery includeKey:@"author"];
    UserQuery.limit = 50;
    UserQuery.cachePolicy = kPFCachePolicyNetworkElseCache;

    //if (![UserQuery hasCachedResult]){
        [UserQuery findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> * _Nullable users, NSError * _Nullable error) {
            if (users) {
                // if arrayOfFoodTrucks is empty and the returned users array doesn't equal arrayOfFoodTrucks
                NSLog(@"users count: %lu", users.count);
                NSLog(@"truck count: %lu", self.arrayOfFoodTrucks.count);
                if (![users isEqualToArray:self.arrayOfFoodTrucks]){
                    
                    if (users.count < self.arrayOfFoodTrucks.count){
                        NSMutableArray *trucksToRemove = [self.arrayOfFoodTrucks mutableCopy];
                        // NSMutableArray *trucksToRemove = [[NSMutableArray alloc] initWithArray:self.arrayOfFoodTrucks copyItems:YES];
                        //NSLog(@"to remove: %lu", trucksToRemove.count);
                        //NSLog(@"%@", users);
                        //NSLog(@"%@", trucksToRemove);
                        trucksToRemove = [self removeDuplicateTrucks:users removeFrom:trucksToRemove];
                        //[trucksToRemove removeObjectsInArray:users];
                        NSLog(@"%lu", self.mapView.annotations.count);
                        NSMutableArray *annotationsToRemove = [self convertRemovedTruckObjectsToAnnotation:trucksToRemove];
                        [self.mapView removeAnnotations:annotationsToRemove];
                        NSLog(@"%lu", self.mapView.annotations.count);
                        [self.arrayOfFoodTrucks removeObjectsInArray:trucksToRemove];
                    }
                    
                    else if (users.count > self.arrayOfFoodTrucks.count){
                        NSMutableArray *trucksToAdd = [users mutableCopy];
                        // NSMutableArray *trucksToAdd = [[NSMutableArray alloc] initWithArray:users copyItems:YES];
                        //NSLog(@"%lu", trucksToAdd.count);
                        [trucksToAdd removeObjectsInArray:self.arrayOfFoodTrucks];
                        //NSLog(@"%lu", trucksToAdd.count);
                        NSMutableArray *annotationsToAdd = [self convertRemovedTruckObjectsToAnnotation:trucksToAdd];
                        //NSLog(@"%lu", annotationsToAdd.count);
                        NSLog(@"%lu", self.mapView.annotations.count);
                        [self.mapView addAnnotations:annotationsToAdd];
                        self.arrayOfAnnotations = [self.mapView.annotations mutableCopy];
                        NSLog(@"%lu", self.mapView.annotations.count);
                        
                        //add objects from array is not working
                        [self.arrayOfFoodTrucks addObjectsFromArray:trucksToAdd];
                        //NSLog(@"%lu", self.arrayOfFoodTrucks.count);
                    }
                }
                
                //NSLog(@"TRUCKS in ARR FOOD TRUCK: %lu", self.arrayOfFoodTrucks.count);
            }
            else {
                NSLog(@"Cannot fetch data");
            }
        }];
    //}
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapFiltersViewController *filtersVC = [segue destinationViewController];
    filtersVC.arrayOfFilters = self.filterArguments;
    filtersVC.formerFoodTrucks = self.arrayOfFoodTrucks;
    filtersVC.formerTruckAnnotations = self.arrayOfAnnotations;
}


@end
