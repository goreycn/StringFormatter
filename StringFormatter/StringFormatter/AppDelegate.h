//
//  AppDelegate.h
//  StringFormatter
//
//  Created by Lyner on 13-9-18.
//  Copyright (c) 2013年 GL. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{

}
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *textfield;
@property (weak) IBOutlet NSTextField *tfSeprator;


- (IBAction)valueChanged:(id)sender;


- (void)actionDone;

@end
