//
//  ViewController.m
//  AVFoundation Test
//
//  Created by Matthew Man on 5/3/2017.
//  Copyright © 2017年 MatthewApp. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <AVCapturePhotoCaptureDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession; // Session
@property (nonatomic, strong) AVCaptureDevice *captureDevice;   // Capture Device
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput; // Device Input
@property (nonatomic, strong) AVCapturePhotoOutput *photoOutput;    // Photo Output
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer; // Preview
@property (nonatomic, strong) AVCapturePhotoSettings *photoSettings;    // Photo setting
@property (nonatomic, assign) AVCaptureFlashMode mode;          //Flash
@property (nonatomic, assign) AVCaptureDevicePosition position; //Position(front/back camera)

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prefersStatusBarHidden];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupCaptureSession];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupCaptureSession
{
    
    self.position = AVCaptureDevicePositionBack;
    
    // 1. Create Session
    self.captureSession = [[AVCaptureSession alloc] init];
    
    // set preview quality
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto])
    {
        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    
    // 2. Setup input device
    self.captureDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:self.position];
    
    // 3. Setup input for the input device
    self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
    
    // 4. Setup output
    self.photoOutput = [[AVCapturePhotoOutput alloc] init];  //iOS10
    
    // 5. Connect session and input
    if ([self.captureSession canAddInput:self.captureDeviceInput]) {
        [self.captureSession addInput:self.captureDeviceInput];
    }
    
    // 6. Connect session and output
    if ([self.captureSession canAddOutput:self.photoOutput]) {
        [self.captureSession addOutput:self.photoOutput];
    }
    
    // 7. Setup the preview
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.frame = self.viewFinder.bounds;
    [self.viewFinder.layer insertSublayer:self.previewLayer atIndex:0];
    
    [self.captureSession startRunning];
    
}

//function to hide the status bar, need to add key in Info.plist
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)takePic:(id)sender
{
    self.photoSettings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecJPEG}];
    [self.photoSettings setFlashMode:self.mode];
    [self.photoOutput capturePhotoWithSettings:self.photoSettings delegate:self];
}

- (IBAction)flashSwitch:(id)sender
{
    if (self.mode == AVCaptureFlashModeOn) {
        [self setMode:AVCaptureFlashModeOff];
    } else {
        [self setMode:AVCaptureFlashModeOn];
    }
}

- (IBAction)changeCam:(id)sender
{
    if (self.position == AVCaptureDevicePositionBack) {
        self.position = AVCaptureDevicePositionFront;
    } else {
        self.position = AVCaptureDevicePositionBack;
    }
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:self.position];
    if (device) {
        self.captureDevice = device;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
        [self.captureSession beginConfiguration];
        [self.captureSession removeInput:self.captureDeviceInput];
        if ([self.captureSession canAddInput:input]) {
            [self.captureSession addInput:input];
            self.captureDeviceInput = input;
            [self.captureSession commitConfiguration];
        }
    }
}

#pragma mark - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput
        didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer
        previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer
        resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings
        bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings
        error:(nullable NSError *)error
        {   NSData *imageData = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); NSLog(@"%s", __FUNCTION__);
        }
@end
