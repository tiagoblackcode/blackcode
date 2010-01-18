//
//  MTHUDController.m
//  MyTunes
//
//  Created by Tiago Melo on 12/30/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTHUDController.h"
#import "MTPreferencesController.h"
#import "MTHUDView.h"


@interface MTHUDController (Private)

- (void)configureBindings;
- (void)configureButtons;
- (void)configureMenu;

@end


@implementation MTHUDController


+ (void)initialize
{
	[self exposeBinding:@"backgroundColor"];
	[self exposeBinding:@"strokeColor"];
	[self exposeBinding:@"minAlphaValue"];
	[self exposeBinding:@"maxAlphaValue"];
}

- (id)init
{

	self = [super init];
	if( self ) {
		maxAlphaValue = 1.0;
		minAlphaValue = 0.0;
	}
	return self;
}


- (void)setMaxAlphaValue:(float)newValue
{
	maxAlphaValue = newValue;
}

- (void)setMinAlphaValue:(float)newValue
{
	minAlphaValue = newValue;
	[[self view] setAlphaValue:minAlphaValue];

}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
	[(MTHUDView*)[self view] setBackgroundColor:backgroundColor];
	[[self view] setNeedsDisplay:YES];
}

- (NSColor*)backgroundColor
{	
	return [(MTHUDView*)[self view] backgroundColor];
}

- (void)setStrokeColor:(NSColor *)strokeColor
{
	[(MTHUDView*)[self view] setStrokeColor:strokeColor];
	
}

- (NSColor*)strokeColor
{
	return [(MTHUDView*)[self view] strokeColor];
}

- (void)loadView
{
	
	NSUInteger resizingMask = NSViewWidthSizable | NSViewMaxXMargin | NSViewHeightSizable | NSViewMinYMargin;
	NSRect hudFrame = NSMakeRect(0,0,100,100);
	hudFrame.origin = NSMakePoint(0, 0);
	
	
	MTHUDView *hud = [[MTHUDView alloc] initWithFrame:hudFrame];

	[hud setAutoresizingMask:resizingMask];
	[hud setAutoresizesSubviews:YES];
	[hud setWantsLayer:YES];
	[hud setController:self];
	
	self.view = hud;
	[self configureBindings];
	[self configureButtons];
	[self configureMenu];
	
	[[self view] addSubview:closeButton];	
	[[self view] addSubview:prefsButton];

}

- (void)configureBindings
{
	NSUserDefaultsController *controller = [NSUserDefaultsController sharedUserDefaultsController];
	[self bind:@"minAlphaValue"
	  toObject:controller
   withKeyPath:[NSString stringWithFormat:@"%@.%@", @"values",kPlayerViewMinAlphaKey]
	   options:nil];
	
	[self bind:@"maxAlphaValue"
	  toObject:controller
   withKeyPath:[NSString stringWithFormat:@"%@.%@", @"values",kPlayerViewMaxAlphaKey]
	   options:nil];
	
	[self bind:@"backgroundColor"
	  toObject:controller
   withKeyPath:[NSString stringWithFormat:@"%@.%@", @"values",kPlayerBackgroundColorKey]
	   options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:NSValueTransformerNameBindingOption]];
	
	[self bind:@"strokeColor"
	  toObject:controller
   withKeyPath:[NSString stringWithFormat:@"%@.%@", @"values",kPlayerTextColorKey]
	   options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:NSValueTransformerNameBindingOption]];

	
}

- (void)configureMenu
{
	[contextualMenu release];
	contextualMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
	
	[[contextualMenu addItemWithTitle:@"Close" action:@selector(orderClose:) keyEquivalent:@""] setTarget:self];
	[[contextualMenu addItemWithTitle:@"Preferences" action:@selector(showPreferences:) keyEquivalent:@""] setTarget:self];
	
}

- (void)orderClose:(id)sender
{
	[[[self view] window] close];
}

- (void)showPreferences:(id)sender
{
	
	[[NSApp delegate] showPreferences:sender];
	
}


- (void)configureButtons
{

//	NSRect frame = NSMakeRect(5, [[self view] frame].size.height - (13+5), 13, 13);
//	closeButton = [[NSButton alloc] initWithFrame:frame];
//	[closeButton setAutoresizingMask:NSViewNotSizable | NSViewMaxXMargin | NSViewMinYMargin];
//	[closeButton setWantsLayer:YES];
//	[closeButton setBordered:NO];
//	[closeButton setBezelStyle:NSRoundedBezelStyle];
//	[closeButton setButtonType:NSMomentaryChangeButton];
//	[closeButton setImage:[NSImage imageNamed:@"hud_titlebar-close"]];
//	[closeButton setTitle:@""];
//	[closeButton setImagePosition:NSImageBelow];
//	[closeButton setFocusRingType:NSFocusRingTypeNone];
	
	
//	frame.origin.x += 13 + 5;
//	prefsButton = [[NSButton alloc] initWithFrame:frame];
//	[prefsButton setAutoresizingMask:NSViewNotSizable | NSViewMaxXMargin | NSViewMinYMargin];
//	[prefsButton setWantsLayer:YES];
//	[prefsButton setBordered:NO];
//	[prefsButton setBezelStyle:NSRoundedBezelStyle];
//	[prefsButton setButtonType:NSMomentaryChangeButton];
//	[prefsButton setImage:[NSImage imageNamed:@"hud_titlebar-close"]];
//	[prefsButton setTitle:@""];
//	[prefsButton setImagePosition:NSImageBelow];
//	[prefsButton setFocusRingType:NSFocusRingTypeNone];
//	[prefsButton setAction:@selector(showPreferences:)];
//	[prefsButton setTarget:[[[self view] window] windowController]];
	
	
//	[closeButton setAction:@selector(orderOut::)];
//	[closeButton setTarget:[[[self view] window] windowController]];
	

	
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
	[NSMenu popUpContextMenu:contextualMenu withEvent:theEvent forView:[self view]];	
}


- (void)mouseEntered:(NSEvent *)theEvent
{
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.5];
	[[closeButton animator] setAlphaValue:1.0];
	[[prefsButton animator] setAlphaValue:1.0];
	[[[self view] animator] setAlphaValue:minAlphaValue+0.3];
	[NSAnimationContext endGrouping];
	
}

- (void)mouseExited:(NSEvent *)theEvent
{
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.5];
	[[closeButton animator] setAlphaValue:0.0];
	[[prefsButton animator] setAlphaValue:0.0];	
	[[[self view] animator] setAlphaValue:minAlphaValue];
	[NSAnimationContext endGrouping];
	
}





@end
 