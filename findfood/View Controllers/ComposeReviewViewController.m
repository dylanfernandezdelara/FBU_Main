//
//  ComposeReviewViewController.m
//  findfood
//
//  Created by dylanfdl on 8/3/21.
//

#import "ComposeReviewViewController.h"
#import "HCSStarRatingView/HCSStarRatingView.h"
#import "Review.h"
#import <ChameleonFramework/Chameleon.h>

@interface ComposeReviewViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingControl;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *reviewDescription;
@property (weak, nonatomic) IBOutlet UIButton *postReviewButton;

@end

@implementation ComposeReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reviewDescription.delegate = self;
    
    self.reviewDescription.layer.borderWidth = 2.0f;
    self.reviewDescription.layer.cornerRadius = 4;
    self.reviewDescription.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.postReviewButton.backgroundColor = [UIColor colorWithHexString:@"3B5B33"];
    self.postReviewButton.tintColor = FlatWhite;
    self.postReviewButton.layer.cornerRadius = 20;
    self.postReviewButton.layer.masksToBounds = true;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSUInteger numChars = textView.text.length;
    self.characterCountLabel.text = [NSString stringWithFormat:@"%lu", 200 - numChars];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text length] == 0 && [textView.text length]!= 0) {
        return YES;
        }
    else if([[textView text] length] > 199) {
            return NO;
        }
    return YES;
}

- (IBAction)postReviewNow:(UIButton *)sender {
    NSNumber *score = [NSNumber numberWithFloat:self.ratingControl.value];
    [Review postReview:self.reviewDescription.text withScore:score forTruck:self.selectedTruckID withName:self.selectedTruckName  withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            Review *newReview = [Review new];
            newReview.reviewContent = self.reviewDescription.text;
            newReview.author = [PFUser currentUser];
            newReview.score = score;
            newReview.truckID = self.selectedTruckID;
            [self.delegate didWriteReview:newReview];
        }
    }];
    
    [self dismissViewControllerAnimated:true completion:^{}];
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
