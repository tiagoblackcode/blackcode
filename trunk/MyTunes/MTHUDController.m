//
//  MTHUDController.m
//  MyTunes
//
//  Created by Tiago Melo on 12/30/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTHUDController.h"
#import "MTTranslucentButtonView.h"
#import "MTPreferencesController.h"
#import "MTHUDView.h"


@interface MTHUDController (Private)

- (void)configureBindings;
- (void)configureButtons;

@end


@implementation MTHUDController

+ (void)initialize
{
	[self exposeBinding:@"backgroundColor"];
	[self exposeBinding:@"strokeColor"];
	[self exposeBinding:@"minAlphaValue"];
	[self exposeBinding:@"maxAlphaValue"];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if( self ) {
		maxAlphaValue = 1.0;
		minAlphaValue = 0.3;
		NSLog(@"initWithNibName:");
	}
	return self;
}


- (void)setFrame:(NSRect)frame
{
	[[self view] setFrame:frame];	
}


- (void)setMaxAlphaValue:(float)newValue
{
	maxAlphaValue = newValue;
}

- (void)setMinAlphaValue:(float)newValue
{
	minAlphaValue = newValue;
	[[self view] setAlphaValue:minAlphaValue];
	[[self view] setNeedsDisplay:YES];
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
	[[self view] setNeedsDisplay:YES];
}

- (NSColor*)strokeColor
{
	return [(MTHUDView*)[self view] strokeColor];
}

	

- (void)loadView
{
	[super loadView];
	[[self view] setAlphaValue:minAlphaValue];
	[self configureBindings];
	[self configureButtons];
	[(MTHUDView*)[self view] setController:self];
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

- (void)configureButtons
{

	NSRect frame = NSMakeRect(5, [[self view] frame].size.height - (13+2), 13, 13);
	closeButton = [[MTTranslucentButtonView alloc] initWithFrame:frame];
	[closeButton setBordered:NO];
	[closeButton setBezelStyle:NSRoundedBezelStyle];
	[closeButton setButtonType:NSMomentaryChangeButton];
	[closeButton setImage:[NSImage imageNamed:@"hud_titlebar-close"]];
	[closeButton setTitle:@""];
	[closeButton setImagePosition:NSImageBelow];
	[closeButton setFocusRingType:NSFocusRingTypeNone];
	
	
	frame.origin.x += 13 + 5;
	prefsButton = [[MTTranslucentButtonView alloc] initWithFrame:frame];
	[prefsButton setBordered:NO];
	[prefsButton setBezelStyle:NSRoundedBezelStyle];
	[prefsButton setButtonType:NSMomentaryChangeButton];
	[prefsButton setImage:[NSImage imageNamed:@"hud_titlebar-close"]];
	[prefsButton setTitle:@""];
	[prefsButton setImagePosition:NSImageBelow];
	[prefsButton setFocusRingType:NSFocusRingTypeNone];	
	
	
	
	[closeButton setAction:@selector(orderOut:)];
	[closeButton setTarget:[[[self view] window] windowController]];
	
	[prefsButton setAction:@selector(showPreferences:)];
	[prefsButton setTarget:[[[self view] window] windowController]];
	
	[[self view] addSubview:closeButton];	
	[[self view] addSubview:prefsButton];
	[[self view] setNeedsDisplay:YES];
	
}

- (void)mouseEntered:(NSEvent *)theEvent
{
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.5];
	[[closeButton animator] setAlphaValue:1.0];
	[[prefsButton animator] setAlphaValue:1.0];
	[[[self view] animator] setAlphaValue:maxAlphaValue];
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
 