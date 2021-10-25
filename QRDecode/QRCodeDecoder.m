//  QRCodeDecoder.m
//  QRDecode
//
//  Created by david on 10/22/21.
//

#import "QRCodeDecoder.h"
#import <Vision/Vision.h>

@interface QRCodeDecoder()
@property(nonatomic) VNImageRequestHandler *handler;
@end

@implementation QRCodeDecoder

- (void)qrCodeInImage:(NSImage *)image {
  VNDetectBarcodesRequest *detectQR = [[VNDetectBarcodesRequest alloc] initWithCompletionHandler:
    ^(VNRequest *request, NSError *error) {

    if (error) {
      [self.delegate qrValue:nil error:error];
    } else {
      NSArray *results = request.results;
      BOOL didCallDelegate = NO;
      for (id result in results) {
        if ([result isKindOfClass:[VNBarcodeObservation class]]) {
          VNBarcodeObservation *observation = (VNBarcodeObservation *)result;
          [self.delegate qrValue:observation.payloadStringValue error:nil];
          didCallDelegate = YES;
        }
      }
      if (!didCallDelegate) {
        NSError *err = [NSError errorWithDomain:@"App" code:1 userInfo:nil];
        [self.delegate qrValue:nil error:err];
      }
    }

  }];
  detectQR.symbologies = @[VNBarcodeSymbologyQR];
  CGImageRef cgImage = [image CGImageForProposedRect:NULL context:NULL hints:NULL];
  self.handler = [[VNImageRequestHandler alloc] initWithCGImage:cgImage options:@{}];
  [self.handler performRequests:@[detectQR] error:NULL];

}

@end
