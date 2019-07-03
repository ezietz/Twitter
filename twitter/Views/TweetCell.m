//
//  TweetCell.m
//  twitter
//
//  Created by ezietz on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted == NO) {
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            } }];
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [self.retweetIcon setSelected:YES];
        [self refreshData];
    }
    else{
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            } }];
        
        self.tweet.retweeted = NO;
        self.tweet.retweetCount += -1;
        [self.retweetIcon setSelected:NO];
        [self refreshData];
    }
    
}
- (IBAction)didTapLike:(id)sender {
    
    if (self.tweet.favorited == NO) {
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            } }];
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self.favorIcon setSelected:YES];
        [self refreshData];
        
    }
    
    else{
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            } }];
        
        self.tweet.favorited = NO;
        self.tweet.favoriteCount += -1;
        [self.favorIcon setSelected:NO];
        [self refreshData];
    }
}

- (void) refreshData {
    
    User *tweetUser = self.tweet.user;
    self.authorView.text = tweetUser.name;
    self.userView.text = tweetUser.screenName;
    self.dateView.text = self.tweet.createdAtString;
    self.tweetView.text = self.tweet.text;
    [self.favorIcon setImage: [UIImage imageNamed:@"favor-icon"]
                    forState: UIControlStateNormal];
    [self.favorIcon setImage: [UIImage imageNamed:@"favor-icon-red"]
                    forState: UIControlStateSelected];
    [self.retweetIcon setImage: [UIImage imageNamed:@"retweet-icon"]
                      forState: UIControlStateNormal];
    [self.retweetIcon setImage: [UIImage imageNamed:@"retweet-icon-green"]
                      forState: UIControlStateSelected];
    
    NSString *profileImageURL = tweetUser.profileImage;
    NSURL *imageURL = [NSURL URLWithString:profileImageURL];
    [self.posterView setImageWithURL:imageURL];
    
}

@end
