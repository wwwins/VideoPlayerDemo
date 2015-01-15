//
//  ViewController.m
//  VideoPlayerDemo
//
//  Created by wwwins on 2014/10/22.
//  Copyright (c) 2014年 isobar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


@implementation ViewController

@synthesize moviePlayer = _moviePlayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playMovie:(id)sender
{
  //NSURL *url = [NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];
  NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mp4"]];
#ifdef SIMPLE_MOVIE_VIEW_CONTROLLER
  MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlayBackDidFinish:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:nil];
  [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
  [moviePlayerViewController.moviePlayer prepareToPlay];
  [moviePlayerViewController.moviePlayer play];
  
#else
  _moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:url];
//  _moviePlayer.controlStyle = MPMovieControlStyleDefault;
  _moviePlayer.controlStyle = MPMovieControlStyleNone;
  _moviePlayer.shouldAutoplay = YES;
//  _moviePlayer.scalingMode = MPMovieScalingModeFill;
  _moviePlayer.scalingMode = MPMovieScalingModeAspectFill;

#ifdef PLAY_FULL_SCREEN
  // 全螢幕的時候只抓得到 MPMoviePlayerWillExitFullscreenNotification
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlayBackDidFinishForFullScreen:)
                                               name:MPMoviePlayerWillExitFullscreenNotification
                                             object:nil];
  
  [self.view addSubview:_moviePlayer.view];
  [self.view sendSubviewToBack:_moviePlayer.view];
  [_moviePlayer setFullscreen:YES animated:YES];
#else
  // 非全螢幕的時候才抓得到 MPMoviePlayerPlaybackDidFinishNotification
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlayBackDidFinish:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:nil];
  
//  CGRect viewInsetRect = CGRectInset ([self.view bounds], 5, 5);
//  [_moviePlayer.view setFrame:viewInsetRect];
//  [_moviePlayer.view setFrame:CGRectMake(0, 0, 320, 150)];
  [_moviePlayer.view setFrame:self.view.frame];
  [_moviePlayer.view setAlpha:0.0];
  [self.view addSubview:_moviePlayer.view];
  [_moviePlayer play];

  // add fade in
#ifdef FADE_IN_OUT
  [self performSelector:@selector(movieFadeIn) withObject:nil];
#endif
  
#endif
  
#endif
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
  NSNumber *reason = [notification userInfo][MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
  NSLog(@">>>>reason:%@",reason);
  
  MPMoviePlayerController *player = [notification object];
  [[NSNotificationCenter defaultCenter]
   removeObserver:self
   name:MPMoviePlayerPlaybackDidFinishNotification
   object:nil];
  
  if ([player respondsToSelector:@selector(setFullscreen:animated:)])
  {
#ifdef FADE_IN_OUT
    [self performSelector:@selector(movieFadeOut) withObject:nil];
#else
    [player.view removeFromSuperview];
#endif
  }
}

- (void)moviePlayBackDidFinishForFullScreen:(NSNotification *)notifiaction
{
  NSLog(@">>>>Exit Full Screen");

  [[NSNotificationCenter defaultCenter]
   removeObserver:self
   name:MPMoviePlayerWillExitFullscreenNotification
   object:nil];
}

#pragma mark - Fade in/out

- (void)movieFadeIn
{
  [UIView animateWithDuration:2.0 animations:^{
    _moviePlayer.view.alpha = 1.0f;
  } completion:nil];
}

- (void)movieFadeOut
{
  [UIView animateWithDuration:2.0 animations:^{
    _moviePlayer.view.alpha = 0.0;
  } completion:^(BOOL finish){
    [_moviePlayer.view removeFromSuperview];
  }];
}

@end
