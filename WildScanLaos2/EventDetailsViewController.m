//
//  EventDetailsViewController.m
//  WildScan
//
//  Created by Shabir Jan on 10/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "EventDetailsViewController.h"

@interface EventDetailsViewController ()

@end

@implementation EventDetailsViewController
@synthesize currentEvent;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:self.currentEvent.eventImageUrl]];
    if (self.imageView.image == nil) {
        self.imageView.image = [UIImage imageNamed:@"empty_photo"];
    }
    UIFont *boldFont = [UIFont systemFontOfSize:15 weight:1];
    
    
    NSString *offense = [NSString stringWithFormat:@"Offense:\n%@",currentEvent.eventIncident];
    
    NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc]initWithString:offense];
    
    NSRange boldRange = [offense rangeOfString:@"Offense:"];
    [attributedName setAttributes:@{ NSFontAttributeName: boldFont } range:boldRange];
   
    self.lblOffense.attributedText = attributedName;
    
    NSString *Address = [NSString stringWithFormat:@"Address:\n%@",currentEvent.eventLocationAddress];
    attributedName = [[NSMutableAttributedString alloc]initWithString:Address];
    boldRange = [Address rangeOfString:@"Address:"];
    [attributedName setAttributes:@{ NSFontAttributeName: boldFont } range:boldRange];
    
    self.lblAddress.attributedText = attributedName;
    
    NSString *country = [NSString stringWithFormat:@"Country:\n%@",currentEvent.eventCountry];
     attributedName = [[NSMutableAttributedString alloc]initWithString:country];
    boldRange = [country rangeOfString:@"Country:"];
    [attributedName setAttributes:@{ NSFontAttributeName: boldFont } range:boldRange];
    
    self.lblCountry.attributedText = attributedName;
    
    NSString *date = [NSString stringWithFormat:@"Date and time:\n%@",currentEvent.eventDateTime];
     attributedName = [[NSMutableAttributedString alloc]initWithString:date];
    boldRange = [date rangeOfString:@"Date and time:"];
    [attributedName setAttributes:@{ NSFontAttributeName: boldFont } range:boldRange];
    
    self.lblDate.attributedText = attributedName;
    
    Species *species = [Species getSpecieByID:currentEvent.eventSpecies moc:self.moc];
    NSString *specieName = [NSString stringWithFormat:@"Species:\n%@",species.specieCommonName];
     attributedName = [[NSMutableAttributedString alloc]initWithString:specieName];
    boldRange = [specieName rangeOfString:@"Species:"];
    [attributedName setAttributes:@{ NSFontAttributeName: boldFont } range:boldRange];
    
    self.lblSpecies.attributedText = attributedName;
    
    NSString *amount = [NSString stringWithFormat:@"Amount:\n%@ %@",currentEvent.eventNumber,currentEvent.eventNumberUnit];
     attributedName = [[NSMutableAttributedString alloc]initWithString:amount];
    boldRange = [amount rangeOfString:@"Amount:"];
    [attributedName setAttributes:@{ NSFontAttributeName: boldFont } range:boldRange];
    
    self.lblAmount.attributedText = attributedName;

    
    NSString *condition = [NSString stringWithFormat:@"Condition:\n%@",currentEvent.eventIncidentCondition];
     attributedName = [[NSMutableAttributedString alloc]initWithString:condition];
    boldRange = [condition rangeOfString:@"Condition:"];
    [attributedName setAttributes:@{ NSFontAttributeName: boldFont } range:boldRange];
    
    self.lblCondition.attributedText = attributedName;

    
    

    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
