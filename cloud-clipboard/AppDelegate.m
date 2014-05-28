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
    // Connect to socket port on localhost
    _gcdSocket = [[SocketExtend alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_gcdSocket initialize];

    // Start background thread
    dispatch_queue_t q_background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(q_background, ^{
        [self backgroundLoop];
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
    
    //store data in variable
    currentPasteboardData = [pasteboard readObjectsForClasses:classes options:options];
    
    //display data in menu item
    [_Menu1 setTitle: currentPasteboardData[0]];
}

/*
 * Runs loop in the background
 *
 */
- (void)backgroundLoop
{
    //actions to do in the loop
    
    //get data from socket
    [_gcdSocket readSocketData];
    
    //get data from pasteboard
    [self fetchPasteboardContent];
    
    //loop this function, no code after this will be executed
    dispatch_queue_t q_background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, q_background, ^(void){
        [self backgroundLoop];
    });
}

/*
 * Method called on opening of the menu
 *
 */
-(void)awakeFromNib
{
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] self];
    [statusItem setTitle:@"Clip"];
    [statusItem setMenu:statusMenu];
}


/*
 * Method called on click of menu item containing copied content
 * Sending paste item (listen by using nc -l 6000 in terminal)
 */
-(void)getPasteItem:(id)sender
{
    [_gcdSocket writeSocketData:currentPasteboardData[0]];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// CODE THAT NEEDS TO BE IN SAME FILE AS INSTANCE OF SOCKETEXTEND //////////////////////////////////
// METHODS ARE FORWARDED TO SOCKETEXTEND ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


/*
 * Called on socket connection
 *
 */
- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    [_gcdSocket didConnectToHost:host port:port];
}

/*
 * Method called on writing data
 *
 */
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [_gcdSocket didWriteDataWithTag:tag];
}

/*
 * Method called on retrieving data
 *
 */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [_gcdSocket didReadData:data withTag:tag];
    //NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"Received: %@", str);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


@end
