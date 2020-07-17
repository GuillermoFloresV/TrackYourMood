//
//  composeViewController.m
//  TrackYourMood
//
//  Created by gfloresv on 7/16/20.
//  Copyright © 2020 gfloresv. All rights reserved.
//

#import "composeViewController.h"

@interface composeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *moodEmojis;
@property (weak, nonatomic) IBOutlet UITextView *moodDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *isPublicControl;

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
    }
    return YES;
}
- (IBAction)onTapScreen:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)isPublicControl:(id)sender {
    NSArray *boolean = @[@(YES),@(NO) ];
    BOOL isPublic = [boolean[self.isPublicControl.selectedSegmentIndex] boolValue];
    NSLog(@"%d",isPublic);
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
