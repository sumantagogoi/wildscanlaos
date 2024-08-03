//
//  ReportDetailTableViewCell.h
//  WildScan
//
//  Created by Shabir Jan on 26/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportDetailTableViewCell : UITableViewCell
@property (nonatomic,weak)IBOutlet UILabel *lblDateTime;
@property (nonatomic,weak)IBOutlet UILabel *lblLocation;
@property (nonatomic,weak)IBOutlet UIButton *btnDateTime;
@property (nonatomic,weak)IBOutlet UIButton *btnLocation;
@end
