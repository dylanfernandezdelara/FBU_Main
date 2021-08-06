//
//  Review.m
//  findfood
//
//  Created by dylanfdl on 8/2/21.
//

#import "Review.h"

@implementation Review

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic truckID;
@dynamic truckName;
@dynamic reviewContent;
@dynamic score;

+ (nonnull NSString *)parseClassName {
    return @"Review";
}

+ (void) postReview: (NSString*)reviewDescription withScore: (NSNumber*)score forTruck:(NSString*)truckID withName: (NSString*)name withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Review *newReview = [Review new];
    newReview.reviewContent = reviewDescription;
    newReview.author = [PFUser currentUser];
    newReview.score = score;
    newReview.truckID = truckID;
    newReview.truckName = name;
    
    [newReview saveInBackgroundWithBlock: completion];
}

@end
