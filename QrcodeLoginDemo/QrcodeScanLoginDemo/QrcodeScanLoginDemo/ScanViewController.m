//
//  ScanViewController.m
//  QrcodeScanLoginDemo
//
//  Created by midoks on 2017/6/16.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *layer;

}

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initScan];
}


-(BOOL)isAvailable
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    
    
    return NO;
}

-(void)initScan
{
    
    NSError * error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    session = [[AVCaptureSession alloc] init];
    AVCaptureInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        NSLog(@"input:%@", [error localizedDescription]);
        return;
    }
    
    
    [session addInput:input];
    
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    [session addOutput:output];
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code];
    
    layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    layer.frame = CGRectMake(50, 170, 280, 200);
    [self.view.layer insertSublayer:layer above:0];
    
    [session startRunning];
    

}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate -

-(void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"AVCaptureMetadataOutputObjectsDelegate");
    
    NSString *code = nil;
    
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            code = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            break;
        }
    }
    
    NSLog(@"code:%@", code);
    
    
    [session stopRunning];

}



@end
