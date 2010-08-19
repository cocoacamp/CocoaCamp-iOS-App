
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
	
    if (connection!=nil) { [connection release]; }
    if (data!=nil) { [data release]; }
    NSURLRequest* request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
    connection = [[NSURLConnection alloc]
				  initWithRequest:request delegate:self];
    //TODO error handling, what if connection is nil?
}

+ (NSData *)cachedImageDataFor:(NSURL*)url{
	return [imageData objectForKey: [url absoluteURL]];
}

- (void)connection:(NSURLConnection *)theConnection
	didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
		data =
		[[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)finish{
    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
	
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageWithData:data]] autorelease];
	
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );
	
    [self addSubview:imageView];
    imageView.frame = self.bounds;
    [imageView setNeedsLayout];
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
	[requestURL release];
    [data release];
    [super dealloc];
}

@end


