//
//  GEOfence.h
//  IMHBDBT
//
//  Created by David Haylock on 06/06/2018.
//

#ifndef GEOfence_h
#define GEOfence_h

#include "IMHBDMain.h"

//-----------------------------------------------------
class GEOfence {
    public:
        GEOfence() {}
        ~GEOfence() {}
    
        GEOfence(string id, float lat, float lng, float radius, bool entered) {
            this->id = id;
            this->lat = lat;
            this->lng = lng;
            this->radius = radius;
            this->entered = entered;
        }
    
        string id;
        float lat;
        float lng;
        float radius;
        bool entered = false;
        bool planted = false;
        float distance = -1.0f;
};

#endif /* GEOfence_h */
