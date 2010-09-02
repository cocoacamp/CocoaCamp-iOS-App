//
//  SearchResultsModel.m
//
//  Created by Keith Lazuka on 7/25/09.
//

#import "SearchResultsModel.h"
#import "FlickrSearchResultsModel.h"

SearchService CurrentSearchService = SearchServiceDefault;
SearchResponseFormat CurrentSearchResponseFormat = SearchResponseFormatDefault;

id<SearchResultsModel> CreateSearchModel(SearchService service, SearchResponseFormat responseFormat)
{
    id<SearchResultsModel> model = nil;
    switch ( service ) {
        case SearchServiceFlickr:
            model = [[[FlickrSearchResultsModel alloc] initWithResponseFormat:responseFormat] autorelease];
            break;
        default:
            [NSException raise:@"CurrentSearchService unknown" format:@""];
            break;
    }
    return model;
}

id<SearchResultsModel> CreateSearchModelWithCurrentSettings(void)
{
    return CreateSearchModel(CurrentSearchService, CurrentSearchResponseFormat);
}