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
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@end

@implementation composeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.moodDescription.textColor = [UIColor lightGrayColor];
    self.moodDescription.text = @"Talk about your day here...";
    self.moodDescription.delegate = self;
    
    //disables the button so that users cant post the preset text
    _postButton.enabled = NO;
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
    //allows me to grab the users email
    FIRUser *user = [FIRAuth auth].currentUser;
    NSLog(@"Currently logged in and trying to post is: %@",user.email);
    NSString *email = user.email;
    //gets user data so that we can know who posted

    //convert the NSNumber to int!
    NSLog(@"Rating for this post is: %@",_emojiRating);
    int intRating = [self.emojiRating intValue];
    NSLog(@"Rating for this post is: %i",intRating);
    
    //this handles the edge case of the user not selecting if the post is public or not (it makes it public automatically
    //because that is where the segmented control defaults 
    if(self.isPublicBool == nil){
        BOOL defaultPrivacy = YES;
        self.isPublicBool = [NSNumber numberWithBool:defaultPrivacy];
    }
        //push the post to the DB (uses addDocumentWithData in order to post without having to use a specified document path
    [[db collectionWithPath:@"posts"] addDocumentWithData:@{
        @"message": self.moodDescription.text,
        @"rating": [NSNumber numberWithInt:intRating],
        @"username": email,
        @"isPublic": self.isPublicBool,
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
    [self enableButton];
}
- (IBAction)tapContent:(id)sender {
    self.emojiRating =@4;
    NSLog(@"Rating is: %@",self.emojiRating);
    [self enableButton];
}
- (IBAction)tapOkay:(id)sender {
    self.emojiRating = @3;
    NSLog(@"Rating is: %@",self.emojiRating);
    [self enableButton];
}
- (IBAction)tapDiscontent:(id)sender {
    self.emojiRating = @2;
    NSLog(@"Rating is: %@",self.emojiRating);
    [self enableButton];
}
- (IBAction)tapSad:(id)sender {
    self.emojiRating = @1;
    NSLog(@"Rating is: %@",self.emojiRating);
    [self enableButton];
}


-(void)enableButton{
    if(self.moodDescription.text.length >0 && ![self.moodDescription.text  isEqual: @"Talk about your day here..."])
    {
        //re-enables the button to be able to post things
        _postButton.enabled = YES;
    }
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
