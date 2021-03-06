//
//  homeViewController.m
//  TrackYourMood
//
//  Created by gfloresv on 7/13/20.
//  Copyright © 2020 gfloresv. All rights reserved.
//

#import "homeViewController.h"
#import "AppDelegate.h"
#import "PostCell.h"
@import Firebase;
@import FirebaseFirestore;
@interface homeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *postsTableView;
@property (strong, nonatomic) NSMutableArray *postArray;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation homeViewController

- (void)viewDidLoad {
    self.postsTableView.delegate = self;
    self.postsTableView.dataSource = self;
    self.postsTableView.rowHeight = 125;
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.postsTableView insertSubview:self.refreshControl atIndex:0];
    
    //initializes the array that holds our posts
    self.postArray = [[NSMutableArray alloc] init];
    FIRUser *user =[FIRAuth auth].currentUser;
    NSLog(@"%@", user.email);
    
    //grabs our posts
    FIRFirestore *db = [FIRFirestore firestore];
    [[db collectionWithPath:@"posts"]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
          if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
          } else {
            for (FIRDocumentSnapshot *document in snapshot.documents) {
                //adds the post data into an array
                [self.postArray addObject:document.data];
                
            }
          }
                    [self.postsTableView reloadData];
        }];
}
- (void)beginRefresh:(UIRefreshControl *)refreshFeed {
    //this removes all objects inside of the post array in order to ensure that we are grabbing all of the posts on Firebase
    self.postArray.removeAllObjects;
    FIRFirestore *db = [FIRFirestore firestore];
    [[db collectionWithPath:@"posts"]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
          if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
          } else {
            for (FIRDocumentSnapshot *document in snapshot.documents) {
                //adds the post data into an array
                    //this means that the document is public, therefore it does get shown
                    [self.postArray addObject:document.data];
                
            }
          }
        [self.postsTableView reloadData];
        [self.refreshControl endRefreshing];
        }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)postsTableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PostCell *cell = [postsTableView dequeueReusableCellWithIdentifier:(@"PostCell")];
    NSDictionary *postData = self.postArray[indexPath.row];
    
    cell.postLabel.text = postData[@"message"];
    cell.usernameLabel.text = postData[@"user"];
    NSNumber *rating = postData[@"rating"];
    cell.emojiLabel.text = [self showEmojiRating: rating];
    NSLog(@"Document Data: %@", postData.description);
    // Get a reference to the storage service using the default Firebase App
    FIRStorage *storage = [FIRStorage storage];

    // Create a storage reference from our storage service
    FIRStorageReference *storageRef = [storage reference];

    NSString *path = [@"profilepictures/" stringByAppendingString :postData[@"user"]];
    NSLog(@"Path: %@", path);
    FIRStorageReference *currPFP = [storageRef child: path];

    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
    [currPFP dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData *data, NSError *error){
      if (error != nil) {
        // Uh-oh, an error occurred!
          NSLog(@"error occured: %ld", (long)error.code);
          //here (if there is no pfp, then the user will not have a personalized image)
      } else {
          NSLog(@"changing pfp");
        // Data for "images/curruser.jpg" is returned
        UIImage *pfp = [UIImage imageWithData:data];
          [cell.profilePictureView setImage:pfp ];
      }
    }];
    return cell;
    }

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Number of things inside the post array: %lu",(unsigned long)self.postArray.count);
    return self.postArray.count;
}

-(NSString*)showEmojiRating:(NSNumber *)number{
    NSNumber *five = @5;
    NSNumber *four = @4;
    NSNumber *three = @3;
    NSNumber *two = @2;
    NSLog(@"Number being passed to the function: %@", number);
    if([number doubleValue] == [five doubleValue]){
        NSLog(@"five is equal to the num");
        return @"😃";
    }
    if([number doubleValue] == [four doubleValue]){
        NSLog(@"four is equal to the num");
        return @"🙂";
    }
    if([number doubleValue] == [three doubleValue]){
        NSLog(@"three is equal to the num");
        return @"😐";
    }
    if([number doubleValue] ==[two doubleValue]){
        NSLog(@"two is equal to the num");
        return @"😕";
    }
    NSLog(@"one is equal to the num");
    return @"😞";
}
@end
