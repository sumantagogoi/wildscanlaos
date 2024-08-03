//
//  GlobalTableViewCell.h
//  WildScan
//
//  Created by Shabir Jan on 28/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlobalTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblSpecies;
@property (weak, nonatomic) IBOutlet UILabel *lblContacts;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckmark;

@property (nonatomic,weak)NSString *regionID;
@end
