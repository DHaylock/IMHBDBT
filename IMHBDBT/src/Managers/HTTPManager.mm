//
//  HTTPManager.cpp
//  It Must Have Been Dark By Then
//
//  Created by David Haylock on 23/05/2018.
//

#include "HTTPManager.h"


//--------------------------------------------------------------
size_t WriteCallback(char *contents, size_t size, size_t nmemb, void *userp)
{
    ((std::string*)userp)->append((char*)contents, size * nmemb);
    return size * nmemb;
}

//--------------------------------------------------------------
void HTTPManager::setRoutes(std::string hostURL, std::string extension, std::string secret) {
    SystemMessage("HTTPManager", "Setting Routes");
    this->hostURL = hostURL;
    this->extension = extension;
    this->secret = secret;
    
    getName();
}

//--------------------------------------------------------------
void HTTPManager::getName() {
    string url = hostURL + "/api/v1/names/get";
    string readBuffer;
    
    CURL *curl;
    CURLcode result;
    
    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL,url.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);
        
        result = curl_easy_perform(curl);
        
        if (result != CURLE_OK) {
            string err = curl_easy_strerror(result);
            SystemMessage("HTTPManager", err.c_str());
        }
        unitid = readBuffer;
//        unitid = regex_replace(readBuffer,std::regex("\""),"");
        cout << "Fetched: " << unitid << endl;
        
        curl_easy_cleanup(curl);
        curl_global_cleanup();
        
        // Turn On
        request(ACTIVATED);
    }
}

//--------------------------------------------------------------
void HTTPManager::request(HTTP_TYPE type, std::string a, std::string b, std::string c) {
    
    CURL *curl;
    CURLcode result;
    
    curl = curl_easy_init();
    if (curl) {
    
        string url = hostURL + "/api/v1/actions";
        string readBuffer;
    
        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
        curl_easy_setopt(curl, CURLOPT_POST,1);
//        curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L);
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0);  // for --insecure option
        
        string s;
    
    
        switch (type) {
            case ACTIVATED: {
                url += "/Activated/"+unitid+"/null/null/null";
            } break;
            case DEACTIVATED: {
                url += "/Deactivated/"+unitid+"/null/null/null";
            } break;
            case PLACED_GPS: {
                url += "/Placed/"+unitid+"/"+a+"/"+b+"/"+c;
            } break;
            case ENTERED_GPS: {
                url += "/Entered/"+unitid+"/"+a+"/"+b+"/"+c;
            } break;
            case EXITTED_GPS: {
                url += "/Exitted/"+unitid+"/"+a+"/"+b+"/"+c;
            } break;
            default: break;
        }
        
        curl_easy_setopt(curl, CURLOPT_URL,url.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);
        
        result = curl_easy_perform(curl);
        
        if (result != CURLE_OK) {
            string err = curl_easy_strerror(result);
            SystemMessage("HTTPManager", err.c_str());
        }
        cout << readBuffer << endl;
//        cout << result << endl;
        
        curl_easy_cleanup(curl);
        curl_global_cleanup();
    }
    else {
        SystemMessage("HTTPManager", "Curl is Broken");
    }
}
