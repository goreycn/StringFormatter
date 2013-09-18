//
//  AppDelegate.m
//  StringFormatter
//
//  Created by Lyner on 13-9-18.
//  Copyright (c) 2013年 GL. All rights reserved.
//

#import "AppDelegate.h"
#import <Carbon/Carbon.h>

EventHandlerUPP hotKeyFunction;

pascal OSStatus hotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent, void *userData)
{
    AppDelegate * appDelegate = (__bridge AppDelegate *)userData;
    [appDelegate actionDone];
    return noErr;
}




@implementation AppDelegate

- (void)actionDone
{
    [self pasteFromBorad];
    [self formatTextfield];
    [self copyToBoard];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    //handler
    hotKeyFunction = NewEventHandlerUPP(hotKeyHandler);
    EventTypeSpec eventType;
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind = kEventHotKeyReleased;
    InstallApplicationEventHandler(hotKeyFunction,1,&eventType,(__bridge void *)self,NULL);
    
    //hotkey
    UInt32 keyCode = 23; // 1
    EventHotKeyRef theRef = NULL;
    EventHotKeyID keyID;
    keyID.signature = 'FOO '; //arbitrary string
    keyID.id = 1;
    RegisterEventHotKey(keyCode,cmdKey+shiftKey,keyID,GetApplicationEventTarget(),0,&theRef);
    
    
}

- (IBAction)valueChanged:(id)sender {
    NSSegmentedControl * sc = (NSSegmentedControl *)sender;
    NSInteger i = sc.selectedSegment;
    switch (i) {
        case 0:
            [self pasteFromBorad];
            break;
        case 1:
            [self formatTextfield];
            break;
        case 2:
            [self copyToBoard];
            break;
        default:
            break;
    }
}

- (void)pasteFromBorad
{
    self.textfield.stringValue = [[NSPasteboard generalPasteboard] stringForType:NSPasteboardTypeString];
}

- (void)formatTextfield
{
    NSString * oldStr = self.textfield.stringValue;
    NSArray * allLines = [oldStr componentsSeparatedByString:@"\n"];
    
    NSString * sep = self.tfSeprator.stringValue;
    
    __block NSUInteger maxPostion = 0;
    
    NSMutableArray * ma = [NSMutableArray array];
    
    [allLines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString * line =  (NSString *)obj;
        line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        
        NSRange range = [line rangeOfString:sep];
        if (range.location != NSNotFound) {
            maxPostion = MAX(range.location, maxPostion);
            [ma addObject:line];
        }
    }];
    
    NSMutableArray * result = [NSMutableArray array];
    [ma enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString * line = (NSString *)obj;
        NSString * newline = [self fillSpaceForString:line atIndex:maxPostion];
        [result addObject:newline];
    }];
    
    self.textfield.stringValue = [result componentsJoinedByString:@"\n"];
}

- (void)copyToBoard
{
    [[NSPasteboard generalPasteboard] declareTypes:@[NSPasteboardTypeString] owner:nil];
    [[NSPasteboard generalPasteboard] setString:self.textfield.stringValue forType:NSPasteboardTypeString];
}


- (NSString *)fillSpaceForString:(NSString *)line atIndex:(NSUInteger) position
{
    NSString * sep               = self.tfSeprator.stringValue;
    NSArray * arr                = [line componentsSeparatedByString:sep];
    NSMutableString * newString  = [arr[0] mutableCopy];
    NSUInteger spaceCountForFill = position - newString.length;
    
    for (int i = 0; i < spaceCountForFill; i++) {
        [newString appendString:@" "];
    }
    
    [newString appendString:sep];
    [newString appendString:[arr[1] copy]];
    
    return newString;
}

@end
