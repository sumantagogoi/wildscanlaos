//
//  AddContactTableViewCell.h
//  WildScan
//
//  Created by Shabir Jan on 04/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddContactTableViewCell : UITableViewCell
@property (nonatomic,weak)IBOutlet UILabel *lblName;
@property (nonatomic,weak)IBOutlet UIButton *btnAddContact;
@property (nonatomic)BOOL isButtonAdd;
@end
