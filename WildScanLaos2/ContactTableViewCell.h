//
//  ContactTableViewCell.h
//  WildScan
//
//  Created by Shabir Jan on 14/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell
@property (nonatomic,strong)IBOutlet UILabel *contactName;
@property (nonatomic,strong)IBOutlet UIImageView *contactAvatar;
@property (nonatomic,strong)IBOutlet UIButton *btnFavorite;
@property (nonatomic,strong)IBOutlet UILabel *contactDetails;
@end
