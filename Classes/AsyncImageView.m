<<<<<<< HEAD

#import "AsyncImageView.h"

@implementation AsyncImageView
@synthesize requestURL;

static NSMutableDictionary *imageData;


- (void)loadImageFromURL:(NSURL*)url {
	self.requestURL = url;
	
	if (imageData) {
		NSMutableData *cachedData;
		cachedData = [imageData objectForKey:[url absoluteURL]];
		if (cachedData != NULL){
			data = cachedData;
			[self finish];
		}
	}
	
=======
@interface AsyncImageView : UIView {
    NSURLConnection* connection;
    NSMutableData* data;
}
@end

@implementation AsyncImageView

- (void)loadImageFromURL:(NSURL*)url {
>>>>>>> 858ddc0ae162adb625b3d5af3635e4992fb0b4ab
    if (connection!=nil) { [connection release]; }
    if (data!=nil) { [data release]; }
    NSURLRequest* request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
    connection = [[NSURLConnection alloc]
				  initWithRequest:request delegate:self];
    //TODO error handling, what if connection is nil?
}

<<<<<<< HEAD
+ (NSData *)cachedImageDataFor:(NSURL*)url{
	return [imageData objectForKey: [url absoluteURL]];
}

=======
>>>>>>> 858ddc0ae162adb625b3d5af3635e4992fb0b4ab
- (void)connection:(NSURLConnection *)theConnection
	didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
		data =
		[[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

<<<<<<< HEAD
- (void)finish{
=======
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
    [connection release];
    connection=nil;
	
>>>>>>> 858ddc0ae162adb625b3d5af3635e4992fb0b4ab
    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
	
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageWithData:data]] autorelease];
	
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );
	
    [self addSubview:imageView];
    imageView.frame = self.bounds;
    [imageView setNeedsLayout];
<<<<<<< HEAD
    [self setNeedsLayout];	
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
    [connection release];
    connection=nil;
	if (imageData == NULL){
		imageData = [[NSMutableDictionary alloc] initWithCapacity:20];
	}
	
	[imageData setObject:data forKey: [self.requestURL absoluteURL]];
	NSLog(@"Saved %@ to cache.", [self.requestURL absoluteURL]);
	
	[self finish];
=======
    [self setNeedsLayout];
>>>>>>> 858ddc0ae162adb625b3d5af3635e4992fb0b4ab
    [data release];
    data=nil;
}

- (UIImage*) image {
    UIImageView* iv = [[self subviews] objectAtIndex:0];
    return [iv image];
}

- (void)dealloc {
    [connection cancel];
    [connection release];
<<<<<<< HEAD
	[requestURL release];
=======
>>>>>>> 858ddc0ae162adb625b3d5af3635e4992fb0b4ab
    [data release];
    [super dealloc];
}

@end