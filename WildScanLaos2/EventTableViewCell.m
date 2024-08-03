//
//  EventTableViewCell.m
//  WildScan
//
//  Created by Shabir Jan on 09/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell
@synthesize lblDate,lblSpecie,lblCountry,lblEventDetail,eventImage;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
