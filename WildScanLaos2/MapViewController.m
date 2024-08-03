//
//  MapViewController.m
//  WildScan
//
//  Created by Shabir Jan on 18/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "MapViewController.h"
#import "Events.h"
#import "EventsViewController.h"
#import "EventDetailsViewController.h"
@interface MapViewController ()
@property (nonatomic,strong)NSMutableArray *allEvents;
@property (nonatomic,strong)NSMutableArray *allAnnotations;
@property (nonatomic,strong)Events *selectedEvent;
@end

@implementation MapViewController
@synthesize allEvents;
@synthesize allAnnotations;
@synthesize selectedEvent;
- (void)viewDidLoad {
    [super viewDidLoad];
    allEvents = [NSMutableArray arrayWithArray:[Events getAllEvents:self.moc]];
    
    for (Events *obj in allEvents) {
        CLLocation *coordinate = [[CLLocation alloc]initWithLatitude:[obj.eventLocationLat doubleValue] longitude:[obj.eventLocationLong doubleValue]];
        [self addAnnotationonMap:coordinate obj:obj];
    }
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
    [self.eventView addGestureRecognizer:tap];
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
    // Do any additional setup after loading the view.
}
-(void)addAnnotationonMap:(CLLocation*)coordinate obj:(Events*)obj{
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    
    point.coordinate = coordinate.coordinate;
    Species *currentSpecie = [Species getSpecieByID:obj.eventSpecies moc:self.moc];
    point.title = currentSpecie.specieCommonName;
    point.subtitle = obj.eventIncident;
    [self.mapView addAnnotation:point];
    [allAnnotations addObject:point];
    
}
-(void)tapEvent{
    Events *currentEvent = selectedEvent;
    
    EventDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetailsVC"];
    vc.moc = self.moc;
    vc.currentEvent = currentEvent;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{

    double lat =   view.annotation.coordinate.latitude;
    double longi = view.annotation.coordinate.longitude;
    for (Events *obj in allEvents) {
        if ([obj.eventLocationLat doubleValue] == lat && [obj.eventLocationLong doubleValue] == longi) {
            selectedEvent = obj;
            
            self.eventCountry.text = obj.eventCountry;
            Species *species = [Species getSpecieByID:obj.eventSpecies moc:self.moc];
            self.eventSpecieName.text = species.specieCommonName;
            self.eventDate.text = obj.eventIncidentDate;
            self.eventDesc.text = obj.eventIncident;
            if (obj.eventImageUrl == nil || [obj.eventImageUrl isEqualToString:@""]) {
                self.eventImage.image = [UIImage imageNamed:@"empty_photo"];
            }else{
                self.eventImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:obj.eventImageUrl]];
            }
            self.eventView.hidden = NO;

        }
       
    }
    
    
}

- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnShowListingPressed:(id)sender {
    BOOL isVCFound = NO;
    NSMutableArray *allControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (id object in allControllers) {
        if ([object isKindOfClass:[EventsViewController class]]) {
            [self.navigationController popToViewController:object animated:YES];
            isVCFound = YES;
        }
    }
    if (isVCFound) {
        
    }else{
        EventsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsVC"];
        vc.moc = self.moc ;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
