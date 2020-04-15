/*
  Weekly Assignment 4/16
  by Juliet Buck

  Expects a string of comma-delimted Serial data from Arduino:
  ** field is 0 or 1 as a string (switch)
  ** second fied is 0-4095 (potentiometer)
  ** third field is 0-4095 (LDR) —— NOT YET IMPLEMENTED
  
  
    Will change the background to pink when the button gets pressed

    
 */
 

// Importing the serial library to communicate with the Arduino 
import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;      

// Data coming in from the data fields
// data[0] = "1" or "0"                  -- BUTTON
// data[1] = 0-4095, e.g "2049"          -- POT VALUE
String [] data;

int switchValue;
int potValue;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 2;


//move ball
int minPotValue = 0;
int maxPotValue = 4095;    // will be 1023 on other systems
int minPugSpeed = 0;
int maxPugSpeed = 50;
int hPugMargin = 40;    // margin for edge of screen

int xPugMin;        // calculate on startup
int xPugMax;        // calc on startup
int yPugMin;        // calculate on startup
int yPugMax;        // calc on startup
float pugY;        // calc on startup, use float b/c speed is float
float pugX;        // calc on startup
int direction = -1;    // 1 or -1


PImage img;
PImage img2; 




void setup ( ) {
  size (800,  600);    
  
  // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  myPort  =  new Serial (this, "/dev/cu.SLAB_USBtoUART",  115200); 
  
  //images load
  img = loadImage("img/pug-01.png"); 
  img2 = loadImage("img/pug-02.png"); 
  
  
  // settings for drawing the ball
  ellipseMode(CENTER);
  xPugMin = hPugMargin;
  xPugMax = width - hPugMargin;
  yPugMin = hPugMargin;
  yPugMax = height - hPugMargin;
  pugX = width/2;
  pugY = height/2;
  
    

} 


// We call this to get the data 
void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();  
    
    print(inBuffer);
    
    // This removes the end-of-line from the string 
    inBuffer = (trim(inBuffer));
    
    // This function will make an array of TWO items, 1st item = switch value, 2nd item = potValue
    data = split(inBuffer, ',');
   
   // we have TWO items — ERROR-CHECK HERE
   if( data.length >= 2 ) {
      switchValue = int(data[0]);           // first index = switch value 
      potValue = int(data[1]);               // second index = pot value
   }
  }
} 

//-- change background to pink if we have a button
void draw ( ) {  
  // every loop, look for serial information
  checkSerial();
  drawBackground();
  drawPug(); 

} 


void drawPug() {
  
   image(img, pugX, pugY);

    
   float speed = map(potValue, minPotValue, maxPotValue, minPugSpeed, maxPugSpeed);
   

    
    //-- change speed
    pugX = pugX + (speed * direction);
    pugY = pugY + (speed * direction);
    
    //boundaries
    if( pugX > xPugMax ) {
    direction = -1;    // go left
    pugX = xPugMax;
  }
  else if(  pugY < yPugMin ) {
    direction = 1;    // go right
    pugY = yPugMin;
  }
  
    if( pugY > yPugMax ) {
    direction = -1;    // go left
    pugY = yPugMax;
  }
  else if(  pugY < yPugMin ) {
    direction = 1;    // go right
    pugY = yPugMin;
  }
    
}


// if input value is 1 (from ESP32, indicating a button has been pressed), change the background
void drawBackground() {
   if( switchValue == 1 ) {
    background(255, 227, 255);
      
  //draw "Hi!" at random widths & heights
  fill(255); 
  textSize(60);
  text("Hi!", random(0, width), random(0, height));

 
   } else {
    background(255); 
    

    
}
  }
