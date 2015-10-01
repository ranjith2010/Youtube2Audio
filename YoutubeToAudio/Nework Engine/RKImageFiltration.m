//
//  RKImageFiltration.m
//  YoutubeToAudio
//
//  Created by ranjith on 28/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import "RKImageFiltration.h"

@interface RKImageFiltration ()
@property (nonatomic, readwrite, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readwrite, strong) DataModel *dataModel;
@end

@implementation RKImageFiltration
@synthesize indexPathInTableView = _indexPathInTableView;
@synthesize dataModel = _dataModel;
@synthesize delegate = _delegate;

#pragma mark - Life cycle

- (id)initWithDataModel:(DataModel *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageFiltrationDelegate>)theDelegate{
    
    if (self = [super init]) {
        self.dataModel = record;
        self.indexPathInTableView = indexPath;
        self.delegate = theDelegate;
    }
    return self;
}

#pragma mark -
#pragma mark - Main operation

- (void)main {
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        
        if (!self.dataModel.hasImage)
            return;
        
        UIImage *rawImage = self.dataModel.videoImage;
        UIImage *processedImage = [self applySepiaFilterToImage:rawImage];
        
        if (self.isCancelled)
            return;
        
        if (processedImage) {
            self.dataModel.videoImage = processedImage;
            self.dataModel.filtered = YES;
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageFiltrationDidFinish:) withObject:self waitUntilDone:NO];
        }
    }
    
}


#pragma mark - Filtering image


- (UIImage *)applySepiaFilterToImage:(UIImage *)image {
    
    // This is expensive + time consuming
    CIImage *inputImage = [CIImage imageWithData:UIImagePNGRepresentation(image)];
    
    if (self.isCancelled)
        return nil;
    
    UIImage *sepiaImage = nil;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, inputImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    CIImage *outputImage = [filter outputImage];
    
    if (self.isCancelled)
        return nil;
    
    // Create a CGImageRef from the context
    // This is an expensive + time consuming
    CGImageRef outputImageRef = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    if (self.isCancelled) {
        CGImageRelease(outputImageRef);
        return nil;
    }
    sepiaImage = [UIImage imageWithCGImage:outputImageRef];
    CGImageRelease(outputImageRef);
    return sepiaImage;
}


@end
