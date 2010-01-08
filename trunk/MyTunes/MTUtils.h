/*
 *  MTUtils.h
 *  MyTunes
 *
 *  Created by Tiago Melo on 12/20/09.
 *  Copyright 2009 BlackCode. All rights reserved.
 *
 */

#define DEBUG
#ifdef DEBUG
	#define MTLog( ... ) NSLog( __VA_ARGS__ )
#else
	#define MTLog( ... ) do {} while(0)
#endif

#define MTMax( v1, v2 ) v1 >= v2 ? v1 : v2

#define MTUDControllerKey(key) [NSString stringWithFormat:@"values.%@", key]