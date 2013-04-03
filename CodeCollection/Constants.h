//
//  Constants.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 11/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//
// REQUEST TYPES

typedef enum {
    RequestTypeGET = 0,
    RequestTypePOST = 1
} RequestType;
// RESPONSE FORMAT
typedef enum {
    APIResponseFormatJSON = 0,
    APIResponseFormatXML = 1
} APIResponseFormat;

// QUERY TYPES
typedef enum {
    QueryTypeCategories = 0,
    QueryTypeOffers = 5,
    QueryTypeOffersAllCategories = 53,
    
} QueryType;
#define BASE_URL                                        @"http://www.melbournecentral.com.au"
#define APP_TITLE                                       @"Code Collection"
#define URL_CATEGORIES                                  @"/api/servicecms.svc/GetCategories"
#define URL_OFFERS                                      @"/api/servicecms.svc/GetOffers"
#define URL_OFFERS_ALL_CATEGORIES                       @"/api/servicecms.svc/GetOffersByCategories"
#define DEFAULT_OFFER_IMAGE_SMALL                       @"thumbpic_reward_default.png"
#define DEFAULT_OFFER_IMAGE_BIG                         @"img_merchantreward_dbs.png"
#define IMAGESIZE_SMALL_WIDTH_OFFER     97
#define IMAGESIZE_LARGE_WIDTH_OFFER     320
#
#define TXT_OK                                          @"OK"
#define TXT_CANCEL                                      @"Cancel"
#define TXT_BACK                                        @"Back"
#define TXT_NO_OFFER_IN_STORE                       @"Sorry, no records found in this store";
#define MSG_OFFER_NO_OFFER                  @"No offer"
#define MSG_OFFER_NO_OFFER_IN_OFFERS_2      @"More Offers are listed under \"Browse\"."
#define MSG_NO_INTERNET_CONNECTION                      @"No active connection detected on your device"
#define MSG_NO_RESULTS_DEFAULT                          @"No Results"
#define TXT_NO_OFFERS               @"No \"Offers\" have been added! You can start by finding the \"Offers\" you like and selecting \"Add to planner\".\n\nThose \"Offers\" will be saved to \"My Planner\""
