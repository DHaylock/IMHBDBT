//
//  Button.h
//  IMHBDBT
//
//  Created by David Haylock on 24/05/2018.
//

#ifndef Button_h
#define Button_h

#include <stdio.h>
#include "IMHBDMain.h"
#include "ofxiOS.h"

class Button {
    public:
        ofRectangle rect;
        ofColor _baseColor;
        CenteredFont font;
        ofEvent<string> pressed;
        string _buttonName;
        bool isActive = false;
        bool isOver = false;
        bool enabled = false;
        
        //---------------------------------------------------
        Button() {
            
        }
    
        //---------------------------------------------------
        ~Button() {
            
        }
    
        //---------------------------------------------------
    Button(int x,int y, int width,int height,string buttonName,ofColor baseColor,CenteredFont font,bool useSpecifiedSize = true,ofColor activeColor = ofColor::blue)
        {
            this->font = font;
            
            _baseColor = baseColor;
            _buttonName = buttonName;
            
            if(!useSpecifiedSize) {
                rect.set(x, y, width, height);
            }
            else {
                int w = font.getStringBoundingBox(_buttonName, 0, 0).width;
                int h = font.getStringBoundingBox(_buttonName, 0, 0).height;
                rect.set(x,y,w,h);
                rect.scale(1.2, 1.4);
            }
            
            ofAddListener(ofEvents().touchDown,this,&Button::buttonTouched);
            ofAddListener(ofEvents().touchUp,this,&Button::buttonReleased);
        }
    
        //---------------------------------------------------
        void setEnabled(bool enabled) {
            this->enabled = enabled;
        }
    
        //---------------------------------------------------
        void draw()
        {
            ofPushStyle();
            if(isActive) {
                ofSetColor(_baseColor,200);
            }
            else {
                ofSetColor(_baseColor);
            }
            
            ofDrawRectangle(rect);
            ofPopStyle();
            ofPushStyle();
            ofSetColor(0, 0, 0);
            font.drawStringCentered(_buttonName, rect.getCenter().x,rect.getCenter().y);
            ofSetColor(ofColor::black);
            ofNoFill();
            ofDrawRectangle(rect);
            ofPopStyle();
        }
       
        //---------------------------------------------------
        void buttonTouched(ofTouchEventArgs & touch)
        {
            if(enabled) {
                float x = touch.x;
                float y = touch.y;
                
                if (rect.inside(x,y) && touch.type == ofTouchEventArgs::down) {
                    isActive = !isActive;
                    ofNotifyEvent(pressed, _buttonName,this);
                }
                else {
                    isActive = false;
                }
            }
        }
    
        //---------------------------------------------------
        void buttonReleased(ofTouchEventArgs & touch)
        {
            isActive = false;
        }
};

#endif /* Button_h */
