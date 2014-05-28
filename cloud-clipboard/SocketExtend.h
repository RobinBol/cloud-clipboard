//
//  SocketExtend.h
//  cloud-clipboard
//
//  Created by Robin Bolscher on 06-05-14.
//  Copyright (c) 2014 GreenCoding. All rights reserved.
//

#import "GCDAsyncSocket.h"

@interface SocketExtend : GCDAsyncSocket

-(void)initialize;
-(void)readSocketData;
-(void)writeSocketData:(id)data;
-(void)didConnectToHost:(NSString *)host port:(UInt16)port;
-(void)didWriteDataWithTag:(long)tag;
-(void)didReadData:(NSData *)data withTag:(long)tag;

@end
