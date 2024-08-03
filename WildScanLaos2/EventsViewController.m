//
//  EventsViewController.m
//  WildScan
//
//  Created by Shabir Jan on 10/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "EventsViewController.h"
#import "EventTableViewCell.h"
#import "Events.h"
#import "reverseGeoCoder.h"
#import "EventDetailsViewController.h"
#import "MapViewController.h"
@interface EventsViewController ()
{
    reverseGeoCoder *reverseGeocode;
}
@property (nonatomic,strong)NSMutableArray *events;
@end

@implementation EventsViewController
@synthesize events;
- (void)viewDidLoad {
    [super viewDidLoad];
    events = [NSMutableArray arrayWithArray:[[Events getAllEvents:self.moc] sortedArrayUsingFunction:dateSort1 context:nil]];
    
    reverseGeocode = [[reverseGeoCoder alloc]init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
NSComparisonResult dateSort1(Events *s1, Events *s2, void *context) {
    NSDateFormatter *dateFormatter2;
    dateFormatter2 = [[NSDateFormatter alloc]init];
    // [dateFormatter2 setDateFormat:@""];
    [dateFormatter2 setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter2 setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *d1 = [dateFormatter2 dateFromString:s1.eventIncidentDate];
    NSDate *d2 = [dateFormatter2 dateFromString:s2.eventIncidentDate];
    
    return [d2 compare:d1]; // ascending order
    
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
#pragma mark -
#pragma mark - UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return events.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EventTableViewCell *cell = (EventTableViewCell*)[self.tableview dequeueReusableCellWithIdentifier:@"eventCell"];
    Events *currentObj = [events objectAtIndex:indexPath.row];
    
    cell.lblCountry.text = currentObj.eventCountry;
    Species *species = [Species getSpecieByID:currentObj.eventSpecies moc:self.moc];
    cell.lblSpecie.text = species.specieCommonName;
    cell.lblDate.text = currentObj.eventIncidentDate;
    cell.lblEventDetail.text = currentObj.eventIncident;
    if (currentObj.eventImageUrl == nil || [currentObj.eventImageUrl isEqualToString:@""]) {
        cell.eventImage.image = [UIImage imageNamed:@"empty_photo"];
    }else{
        cell.eventImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:currentObj.eventImageUrl]];
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Events *currentEvent = [events objectAtIndex:indexPath.row];
    
    EventDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetailsVC"];
    vc.moc = self.moc;
    vc.currentEvent = currentEvent;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)btnMapPressed:(id)sender {
    BOOL isVCFound = NO;
    NSMutableArray *allControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (id object in allControllers) {
        if ([object isKindOfClass:[MapViewController class]]) {
            [self.navigationController popToViewController:object animated:YES];
            isVCFound = YES;
        }
    }
    if (isVCFound) {
        
    }else{
        MapViewController *mapVc = [self.storyboard instantiateViewControllerWithIdentifier:@"mapVC"];
        mapVc.moc = self.moc;
        [self.navigationController pushViewController:mapVc animated:YES];
        
    }
    
}
@end
