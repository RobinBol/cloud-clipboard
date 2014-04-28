//
//  AppDelegate.m
//  cloud-clipboard
//
//  Created by Robin Bolscher on 27-03-14.
//  Copyright (c) 2014 GreenCoding. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;

/*
 * Called on launch of application
 *
 */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Start background thread
    dispatch_queue_t q_background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(q_background, ^{
        [self fetchPasteboardContent];
    });
}

/*
 * Fetches content from pasteboard every 0.5 seconds in background
 *
 */
- (void)fetchPasteboardContent
{
    self.whichPboard = [NSPasteboard generalPasteboard];
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *classes = [[NSArray alloc] initWithObjects:[NSString class], nil];
    NSDictionary *options = [NSDictionary dictionary];
    NSArray *copiedItems = [pasteboard readObjectsForClasses:classes options:options];
    [_Menu1 setTitle: copiedItems[0]];

    // Call this method again using GCD
    dispatch_queue_t q_background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, q_background, ^(void){
        [self fetchPasteboardContent];
    });
}

/*
 * Method called on opening of the menu
 *
 */
-(void)awakeFromNib{
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] self];
    [statusItem setTitle:@"Clippy bitch"];
    [statusItem setMenu:statusMenu];
}

/*
 * Method called on click of menu item containing copied content
 *
 */
-(void)getPasteItem:(id)sender {
    
}

@end
