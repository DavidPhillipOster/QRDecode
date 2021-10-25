//  ImageView.h
//  QRDecode
//
//  Created by david on 10/22/21.
//

#import <Cocoa/Cocoa.h>

#import "QRDelegate.h"

// a drop recipient. Calls its delegate back on the QRDelegate if it decodes a QRCode.
@interface ImageView : NSImageView <NSDraggingDestination>
@property(nonatomic, weak) IBOutlet id<QRDelegate> qrDelegate;
@end

