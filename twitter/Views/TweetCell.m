//
//  TweetCell.m
//  twitter
//
//  Created by ezietz on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapLike:(id)sender {
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
}

@end
