//  ImageView.m
//  QRDecode
//
//  Created by david on 10/22/21.
//

#import "ImageView.h"

#import "QRCodeDecoder.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface ImageView()
@property(nonatomic) NSURL *destinationDir;
@property(nonatomic) NSOperationQueue *workQueue;
@property(nonatomic) QRCodeDecoder *decoder;
@property(nonatomic) BOOL isInDrop;
@end

@implementation ImageView

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];
  if (self.isInDrop) {
    CGRect bounds = CGRectInset(self.bounds, 5, 5);
    [NSColor.blueColor set];
    NSFrameRect(bounds);
    bounds = CGRectInset(bounds, 1, 1);
    NSFrameRect(bounds);
  }
}

- (void)setIsInDrop:(BOOL)isInDrop {
  if (_isInDrop != isInDrop) {
    _isInDrop = isInDrop;
    [self setNeedsDisplay:YES];
  }
}

- (NSURL *)destinationDir {
  if (nil == _destinationDir) {
    _destinationDir = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"Drops"];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createDirectoryAtURL:_destinationDir withIntermediateDirectories:YES attributes:@{} error:NULL];
  }
  return _destinationDir;
}

- (NSOperationQueue *)workQueue {
  if (nil == _workQueue) {
    _workQueue = [[NSOperationQueue alloc] init];
    _workQueue.qualityOfService = NSQualityOfServiceUserInitiated;
  }
  return _workQueue;
}

- (QRCodeDecoder *)decoder {
  if (nil == _decoder) {
    _decoder = [[QRCodeDecoder alloc] init];
  }
  return _decoder;
}

- (void)setQrDelegate:(id)qrDelegate {
  self.decoder.delegate = qrDelegate;
}

-(void)setImage:(NSImage *)image {
  if (self.image != image) {
    [super setImage:image];
    [self.decoder qrCodeInImage:image];
  }
}


- (void)handleFileURL:(NSURL *)fileURL{
  NSImage *image = [[NSImage alloc] initWithContentsOfURL:fileURL];
  if (image) {
    self.image = image;
  }
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
  self.isInDrop = YES;
  return NSDragOperationGeneric;
}

- (void)draggingExited:(nullable id <NSDraggingInfo>)sender {
  self.isInDrop = NO;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
  return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
  self.isInDrop = NO;
  [sender enumerateDraggingItemsWithOptions:0
          forView:self
          classes:@[ [NSFilePromiseReceiver class], [NSURL class] ]
          searchOptions:@{NSPasteboardURLReadingFileURLsOnlyKey : @YES,
                          NSPasteboardURLReadingContentsConformToTypesKey :
                            @[ UTTypeImage.identifier]}
          usingBlock:^(NSDraggingItem *dragging, NSInteger idx, BOOL *stop){
            if ([dragging.item isKindOfClass:[NSFilePromiseReceiver class]]) {
              NSFilePromiseReceiver *receiver = (NSFilePromiseReceiver *)dragging.item;
              [receiver receivePromisedFilesAtDestination:self.destinationDir
              options:@{}
              operationQueue:self.workQueue
              reader:^(NSURL *fileURL, NSError *errorOrNil) {
                [self handleFileURL:fileURL];
              }];
            } else if ([dragging.item isKindOfClass:[NSURL class]]) {
              [self handleFileURL:(NSURL *)dragging.item];
            }
          }];
  return YES;
}

- (void)concludeDragOperation:(nullable id <NSDraggingInfo>)sender {
  self.isInDrop = NO;
}


@end
