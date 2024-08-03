//
//  EventDetailsViewController.h
//  WildScan
//
//  Created by Shabir Jan on 10/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Events.h"
@interface EventDetailsViewController : UIViewController
@property (nonatomic,strong)Events *currentEvent;
@property (nonatomic,strong)NSManagedObjectContext *moc;
- (IBAction)btnBackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblOffense;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblSpecies;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblCondition;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
