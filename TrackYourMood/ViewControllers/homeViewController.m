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
                NSNumber *one = @1;
                NSNumber *convertedBool = document.data[@"isPublic"];
                if([convertedBool doubleValue] == [one doubleValue] ){
                    //this means that the document is public, therefore it does get shown
                    [self.postArray addObject:document.data];
                }
            }
          }
                    [self.postsTableView reloadData];
        }];
}
- (void)beginRefresh:(UIRefreshControl *)refreshFeed {
    
    FIRFirestore *db = [FIRFirestore firestore];
    [[db collectionWithPath:@"posts"]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
          if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
          } else {
            for (FIRDocumentSnapshot *document in snapshot.documents) {
                //adds the post data into an array
                NSNumber *one = @1;
                NSNumber *convertedBool = document.data[@"isPublic"];
                if([convertedBool doubleValue] == [one doubleValue] ){
                    //this means that the document is public, therefore it does get shown
                    [self.postArray addObject:document.data];
                }
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
    cell.usernameLabel.text = postData[@"username"];
    NSLog(@"Document Data: %@", postData.description);

    return cell;
    }

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Number of things inside the post array: %lu",(unsigned long)self.postArray.count);
    return self.postArray.count;
}

-(void)showEmojiRating{
    
}
@end
