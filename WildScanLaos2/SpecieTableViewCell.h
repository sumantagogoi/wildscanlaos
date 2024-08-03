//
//  SpecieTableViewCell.h
//  WildScan
//
//  Created by Shabir Jan on 04/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecieTableViewCell : UITableViewCell
@property (nonatomic,strong)IBOutlet UIImageView *specieImage;
@property (nonatomic,strong)IBOutlet UILabel *specieName;
@property (nonatomic,strong)IBOutlet UILabel *specieCites;
@property (nonatomic,strong)IBOutlet UIButton *specieFavoriteBtn;
@property (nonatomic,strong)IBOutlet UIButton *specieReportBtn;
@end
