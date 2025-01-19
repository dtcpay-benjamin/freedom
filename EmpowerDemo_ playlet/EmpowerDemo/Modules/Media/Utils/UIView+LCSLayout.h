//
//  UIView+layout.h
//  DeliverManager
//
//  Created by wangqiwei on 2018/10/23.
//  Copyright © 2018 com.bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LCSLayout)

/**
 * Shortcut for frame.origin.x.
 */
@property (nonatomic) CGFloat lcs_left;

/**
 * Shortcut for frame.origin.y
 */
@property (nonatomic) CGFloat lcs_top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 */
@property (nonatomic) CGFloat lcs_right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 */
@property (nonatomic) CGFloat lcs_bottom;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize lcs_size;

/**
 * Shortcut for frame.size.width
 */
@property (nonatomic) CGFloat lcs_width;

/**
 * Shortcut for frame.size.height
 */
@property (nonatomic) CGFloat lcs_height;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint lcs_origin;

/**
 * Shortcut for frame.origin.x
*/
@property (nonatomic) CGFloat lcs_originX;

/**
 * Shortcut for frame.origin.y
*/
@property (nonatomic) CGFloat lcs_originY;

/**
 * Shortcut for center
*/
@property (nonatomic) CGPoint lcs_center;

/**
 * Shortcut for center.x
*/
@property (nonatomic) CGFloat lcs_centerX;

/**
 * Shortcut for center.y
*/
@property (nonatomic) CGFloat lcs_centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat lcs_screenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat lcs_screenY;



@end

