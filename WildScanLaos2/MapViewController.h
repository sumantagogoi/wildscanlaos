//
//  MapViewController.h
//  WildScan
//
//  Created by Shabir Jan on 18/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong)NSManagedObjectContext *moc;
- (IBAction)btnBackPressed:(id)sender;
- (IBAction)btnShowListingPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *eventView;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UILabel *eventCountry;
@property (weak, nonatomic) IBOutlet UILabel *eventSpecieName;
@property (weak, nonatomic) IBOutlet UILabel *eventDesc;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@end
