//
//  EventTableViewCell.h
//  WildScan
//
//  Created by Shabir Jan on 09/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell
@property (nonatomic,weak)IBOutlet UIImageView *eventImage;
@property (nonatomic,weak)IBOutlet UILabel *lblCountry;
@property (nonatomic,weak)IBOutlet UILabel *lblDate;
@property (nonatomic,weak)IBOutlet UILabel *lblSpecie;
@property (nonatomic,weak)IBOutlet UILabel *lblEventDetail;
@end
