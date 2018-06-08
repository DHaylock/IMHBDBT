//
//  HTTPManager.h
//  It Must Have Been Dark By Then
//
//  Created by David Haylock on 23/05/2018.
//

#ifndef HTTPManager_h
#define HTTPManager_h

#include <stdio.h>
#include "IMHBDMain.h"
#include <curl/curl.h>

class HTTPManager {
    public:
        //--------------------------------------------------------------
        /**
         Create Instance
         
         @return instance
         */
        //--------------------------------------------------------------
        static HTTPManager& instance() {
            static HTTPManager *instance_ = new HTTPManager();
            return *instance_;
        }
    
        //--------------------------------------------------------------
        /**
         Tell the Manager where to send the data

         @param hostURL
         @param extension
         */
        //--------------------------------------------------------------
        void setRoutes(string hostURL,string extension,string secret);
    
        //--------------------------------------------------------------
        /**
         Send the Request

         @param type what sort of request are we sending (Check the ENUM)
         @param a data1
         @param b data2
         @param c data3
         */
        //--------------------------------------------------------------
        void request(HTTP_TYPE type,string a = "",string b = "",string c = "");
    
        //--------------------------------------------------------------
        /**
         Get New Name
         */
        //--------------------------------------------------------------
        void getName();
    
    private:
    
        string hostURL;
        string extension;
        string secret;
        string unitid;
};

#endif /* HTTPManager_h */
