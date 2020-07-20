//
//  composeViewController.m
//  TrackYourMood
//
//  Created by gfloresv on 7/16/20.
//  Copyright © 2020 gfloresv. All rights reserved.
//

#import "composeViewController.h"
#import "SceneDelegate.h"
#import "homeViewController.h"
@import FirebaseFirestore;
@import Firebase;
@import FirebaseAuth;

@interface composeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *moodEmojis;
@property (weak, nonatomic) IBOutlet UITextView *moodDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *isPublicControl;
@property (strong, nonatomic) NSNumber *emojiRating;
@property (strong, nonatomic) NSNumber *isPublicBool;
@end

@implementation composeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.moodDescription.textColor = [UIColor lightGrayColor];
    self.moodDescription.text = @"Talk about your day here...";
    self.moodDescription.delegate = self;
    
    
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)moodDescription{
    //super hacky way to have the placeholder text disappear (want to fix later)
    if([self.moodDescription.text  isEqual: @"Talk about your day here..."]){
        self.moodDescription.text = @"";
        self.moodDescription.textColor = [UIColor blackColor];
        NSNumber *emojiRating;
    }
    return YES;
}
- (IBAction)onTapScreen:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)isPublicControl:(id)sender {
    NSArray *boolean = @[@(YES),@(NO) ];
    BOOL isPublic = [boolean[self.isPublicControl.selectedSegmentIndex] boolValue];
    self.isPublicBool = [NSNumber numberWithBool:isPublic];
    NSLog(@"%d",isPublic);
}
- (IBAction)postAction:(id)sender {
    //initializes the db
    FIRFirestore *db = [FIRFirestore firestore];
    NSString *email = @"testemail@google.com";
    //gets user data so that we can know who posted

    //convert the NSNumber to int!
    NSLog(@"Rating for this post is: %@",_emojiRating);
    int intRating = [self.emojiRating intValue];
    NSLog(@"Rating for this post is: %i",intRating);
    
    //push the post to the DB (uses addDocumentWithData in order to post without having to use a specified document path
    [[db collectionWithPath:@"posts"] addDocumentWithData:@{
        @"message": self.moodDescription.text,
        @"rating": [NSNumber numberWithInt:intRating],
        @"username": email,
        @"isPublic": self.isPublicBool
    } completion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error writing document: %@", error);
        } else {
            NSLog(@"Document successfully written!");
        }
    }];
    //sends us back to the feed page
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)tapHappy:(id)sender {
    self.emojiRating = @5;
    NSLog(@"Rating is: %@",self.emojiRating);
}
- (IBAction)tapContent:(id)sender {
    self.emojiRating =@4;
    NSLog(@"Rating is: %@",self.emojiRating);
}
- (IBAction)tapOkay:(id)sender {
    self.emojiRating = @3;
    NSLog(@"Rating is: %@",self.emojiRating);
}
- (IBAction)tapDiscontent:(id)sender {
    self.emojiRating = @2;
    NSLog(@"Rating is: %@",self.emojiRating);
}
- (IBAction)tapSad:(id)sender {
    self.emojiRating = @1;
    NSLog(@"Rating is: %@",self.emojiRating);
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
