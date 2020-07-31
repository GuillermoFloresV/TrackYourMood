//
//  PostCell.h
//  TrackYourMood
//
//  Created by gfloresv on 7/21/20.
//  Copyright © 2020 gfloresv. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *emojiLabel;

@end

NS_ASSUME_NONNULL_END
