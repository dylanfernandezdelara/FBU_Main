//
//  Review.h
//  findfood
//
//  Created by dylanfdl on 8/2/21.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Review : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *truckID;

@property (nonatomic, strong) NSString *reviewContent;
@property (nonatomic, strong) NSNumber *score;

+ (void) postReview: (NSString*)reviewDescription withScore: (NSNumber*)score forTruck:(NSString*)truckID withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
