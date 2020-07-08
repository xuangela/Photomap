//
//  PhotoMapViewController.m
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Copyright © 2018 Codepath. All rights reserved.
//

// TODO: extra features and bonus

#import "PhotoMapViewController.h"
#import "LocationsViewController.h"
#import <MapKit/MapKit.h>

@interface PhotoMapViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,LocationsViewControllerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapview;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@property (nonatomic, strong)UIImagePickerController *imagePickerVC;
@property (nonatomic, strong) UIImage *picture;

@end

@implementation PhotoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapview.delegate = self;

    //setting map view to LA
    MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapview setRegion:sfRegion animated:false];
    
    //setting up camera view
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
           self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
       }
       else {
           NSLog(@"Camera 🚫 available so we will use photo library instead");
           self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
       }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickCamera:(id)sender {
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude{
    MKCoordinateRegion selectedRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapview setRegion:selectedRegion animated:false];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
    
    // add pin
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = coordinate;
    annotation.title = @"Picture!";
    [self.mapview addAnnotation:annotation];
    
    // add image to pin
    [self mapView:self.mapview viewForAnnotation:annotation];
    
    [self.navigationController popToViewController:self animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    }

    UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
    imageView.image = self.picture;

    return annotationView;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    self.picture = editedImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"tagSegue" sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   LocationsViewController *locationController = [segue destinationViewController];
    locationController.delegate = self;
}


@end
