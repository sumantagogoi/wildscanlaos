//
//  RegionStats.m
//  WildScan
//
//  Created by Shabir Jan on 15/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "RegionStats.h"

@implementation RegionStats

// Insert code here to add functionality to your managed object subclass
+(void)createRegionStat:(NSString *)rid tspecies:(NSString *)totalSpecies tcontacts:(NSString *)totalContacts tusers:(NSString *)totalUsers moc:(NSManagedObjectContext *)moc{
    RegionStats *regionStat = [NSEntityDescription insertNewObjectForEntityForName:@"RegionStats" inManagedObjectContext:moc];
    regionStat.regionStatRID  = rid;
    regionStat.regionStatTotalUsers = totalUsers;
    regionStat.regionStatTotalSpecies = totalSpecies;
    regionStat.regionStatTotalContacts = totalContacts;
    if([rid isEqualToString:@"1"]){
        regionStat.regionIsDownloaded= [NSNumber numberWithBool:YES];
    }else{
        regionStat.regionIsDownloaded= [NSNumber numberWithBool:NO];
    }
    [moc save:nil];
}
+(NSArray*)getAllRegionStats:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RegionStats"
                                              inManagedObjectContext:moc];
    
    [fetchRequest setEntity:entity];
    
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return objects ;

}
+(RegionStats*)getRegionStatForID:(NSString *)rid moc:(NSManagedObjectContext *)moc{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RegionStats"
                                              inManagedObjectContext:moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"regionStatRID == %@",rid];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    
    
    NSError *error = nil;
    
    NSArray *objects = [moc executeFetchRequest:fetchRequest error:&error];
    
    return [objects firstObject] ;
}
@end
