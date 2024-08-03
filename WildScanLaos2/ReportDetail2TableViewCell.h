//
//  ReportDetail2TableViewCell.h
//  WildScan
//
//  Created by Shabir Jan on 27/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportDetail2TableViewCell : UITableViewCell
@property (nonatomic,weak)IBOutlet UITextView *textView;
@property (nonatomic,weak)IBOutlet UITextField *txtSpecies;
@property (nonatomic,weak)IBOutlet UITextField *txtAmount;
@property (nonatomic,weak)IBOutlet UIButton *btnIndividual;
@property (nonatomic,weak)IBOutlet UIButton *btnKg;
@property (nonatomic,weak)IBOutlet UIButton *btnAlive;
@property (nonatomic,weak)IBOutlet UIButton *btnDead;
@property (nonatomic,weak)IBOutlet UIButton *btnMixed;
@property (nonatomic,weak)IBOutlet UIButton *btnSpecie;
@end
