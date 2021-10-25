//  QRViewController.m
//  QRDecode
//
//  Created by david on 10/22/21.
//

#import "QRViewController.h"

#import "ImageView.h"
#import "PasteDelegate.h"
#import "QRDelegate.h"

#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

// From argument list, remove processname
static NSArray<NSString *> *ArgsToFiles(NSArray<NSString *> *args) {
  NSMutableArray<NSString *> *a = [args mutableCopy];
  [a removeObjectAtIndex:0];
  return a;
}

@interface QRViewController() <PasteDelegate, QRDelegate>
@property IBOutlet ImageView *imageView;
@property IBOutlet NSTextView *textView;
@property NSMutableArray<NSURL *> *fileURLs;
@end

@implementation QRViewController {
  NSUndoManager *_undoManager;
}

- (NSUndoManager *)undoManager {
  if (nil == _undoManager) {
    _undoManager = [[NSUndoManager alloc] init];
  }
  return _undoManager;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self openFiles:ArgsToFiles(NSProcessInfo.processInfo.arguments)];

  NSMutableArray *types = [[NSFilePromiseReceiver readableDraggedTypes] mutableCopy];
  [types addObject:UTTypeImage.identifier];
  [self.imageView registerForDraggedTypes:types];

  self.textView.string = NSLocalizedString(@"USAGE", @"");
}

- (IBAction)paste:(id)sender {
  NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
  NSString *typeName = [pasteboard availableTypeFromArray:[NSImage imageTypes]];
  if (typeName) {
    NSImage *image = [[NSImage alloc] initWithPasteboard:pasteboard];
    if (image) {
      self.imageView.image = image;
    }
  }
}

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem {
  SEL action = [anItem action];
  if (action == @selector(openDocument:)) {
    return YES;
  } else if (action == @selector(paste:)) {
    return [self wantsPaste];
  }
  return NO;
}

// set up a queue of file URLS and process all of them.
- (void)openFiles:(NSArray<NSString *> *)files {
  self.fileURLs = [NSMutableArray array];
  for (NSString *file in files) {
    NSURL *url = [NSURL fileURLWithPath:file];
    if (url.path.length) {
      [self.fileURLs addObject:url];
    }
  }
  [self openURLs:self.fileURLs];
}

- (void)openURLs:(NSArray<NSURL *> *)urls {
  for (NSURL *url in urls) {
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
    if (image) {
      [NSDocumentController.sharedDocumentController noteNewRecentDocumentURL:url];
      self.imageView.image = image;
    }
  }
}

// Handle the Open… menu command.
- (IBAction)openDocument:(nullable id)sender {
  NSOpenPanel *openPanel = [NSOpenPanel openPanel];
  openPanel.canChooseFiles = YES;
  openPanel.allowedContentTypes = @[ UTTypeImage ];
  [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result){
    if (NSModalResponseOK == result) {
      [self openURLs:openPanel.URLs];
    }
  }];
}

- (nullable NSUndoManager *)undoManagerForTextView:(NSTextView *)view {
  return self.undoManager;
}

- (BOOL)wantsPaste {
  NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
  return [pasteBoard canReadItemWithDataConformingToTypes:[NSImage imageTypes]];
}


#pragma mark QRDelegate

- (void)qrValue:(NSString *)s error:(NSError *)error {
  self.textView.string = s;
  if (self.fileURLs && 0 != self.fileURLs.count) {
    if (nil == error) {
      printf("%s\n", [s UTF8String]);
    }
    [self.fileURLs removeObjectAtIndex:0];
    if (0 == self.fileURLs.count) {
      exit(error ? 1 : 0);  // 0 is good status value.
    }
  }
}

@end
