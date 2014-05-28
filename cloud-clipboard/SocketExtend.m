//
//  SocketExtend.m
//  cloud-clipboard
//
//  Created by Robin Bolscher on 06-05-14.
//  Copyright (c) 2014 GreenCoding. All rights reserved.
//

#import "SocketExtend.h"

@implementation SocketExtend

-(void)initialize
{    
    // Throw error if not connected
    NSError *err = nil;
    if (![self connectToHost:@"localhost" onPort:5999 error:&err]) // Asynchronous!
    {
        // If there was an error, it's likely something like "already connected" or "no delegate set"
        NSLog(@"Error: %@", err);
    }
    
    [self acceptOnPort:5999 error:&err];
}

/*
 * Read data without timeout, and tag = 0
 *
 */
-(void)readSocketData
{
    [self readDataWithTimeout:-1 tag:0];
}

/*
 * Send data without timeout, and tag = 0
 *
 */
-(void)writeSocketData:(id)data
{
    NSString *newline = @"\n";
    NSString *concatened = [NSString stringWithFormat:@"%@%@", data, newline];
    NSData *parsedData = [concatened dataUsingEncoding:NSUTF8StringEncoding];
    
    [self writeData:parsedData withTimeout:-1 tag:0];
}

/*
 * Called on socket connection
 *
 */
- (void)didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Connected on: %@:%hu", host, port);
    
}

/*
 * Method called on writing data
 *
 */
- (void)didWriteDataWithTag:(long)tag
{
    NSLog(@"Data send with tag %li", tag);
}

/*
 * Method called on writing data
 *
 */
- (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    NSString *parsedData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Send with tag %li: %@", tag, parsedData);
}


/*
 * Method called on retrieving data
 *
 */
- (void)didReadData:(NSData *)data withTag:(long)tag
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Received: %@", str);

    NSString* parsedData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:parsedData forType:NSStringPboardType];

}


@end
