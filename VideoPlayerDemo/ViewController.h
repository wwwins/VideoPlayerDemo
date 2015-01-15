//
//  ViewController.h
//  VideoPlayerDemo
//
//  Created by wwwins on 2014/10/22.
//  Copyright (c) 2014年 isobar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

//#define SIMPLE_MOVIE_VIEW_CONTROLLER
//#define PLAY_FULL_SCREEN
#define FADE_IN_OUT

@interface ViewController : UIViewController

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UIButton *ButtonPlay;

@end
