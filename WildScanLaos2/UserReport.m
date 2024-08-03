//
//  UserReport.m
//  WildScan
//
//  Created by Shabir Jan on 15/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "UserReport.h"

@implementation UserReport

// Insert code here to add functionality to your managed object subclass
+(void)createUserReport:(NSString *)reportString moc:(NSManagedObjectContext *)moc{
    UserReport *userReport = [NSEntityDescription insertNewObjectForEntityForName:@"UserReport" inManagedObjectContext:moc];
    userReport.userReportString = reportString;
    userReport.userReportIsSubmitted = [NSNumber numberWithBool:NO];
    [moc save:nil];
}
+(NSArray*)getAllUnsubmittedReports:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserReport"
                                              inManagedObjectContext:moc];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"userReportIsSubmitted == %@",[NSNumber numberWithBool:NO]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return objects ;
    

}
@end
