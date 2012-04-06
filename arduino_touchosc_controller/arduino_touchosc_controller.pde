import oscP5.*;        //  Load OSC P5 library
import netP5.*;        //  Load net P5 library
import processing.serial.*;    //  Load serial library

Serial arduinoPort;        //  Set arduinoPort as serial connection
OscP5 oscP5;            //  Set oscP5 as OSC connection
NetAddressList myNetAddressList = new NetAddressList();
int outgoingPort = 9000;
int incomingPort = 8000;

int redLED = 0;        //  redLED lets us know if the LED is on or off
int greenLED = 0;        //  greenLED lets us know if the LED is on or off
int [] led = new int [2];    //  Array allows us to add more toggle buttons in TouchOSC
int currentPosA = 0;
int desiredPosA = 0;
int currentPosB = 0;
int desiredPosB = 0;

void setup() {
  size(200,100);        // Processing screen size
  noStroke();            //  We don’t want an outline or Stroke on our graphics
    oscP5 = new OscP5(this,incomingPort);  // Start oscP5, listening for incoming messages at port 8000
   arduinoPort = new Serial(this, Serial.list()[0], 9600);    // Set arduino to 9600 baud
}

void oscEvent(OscMessage theOscMessage) {   //  This runs whenever there is a new OSC message
  
    connect(theOscMessage.netAddress().address());
    
    String addr = theOscMessage.addrPattern();  //  Creates a string out of the OSC message
    if(addr.indexOf("/1/servoA") !=-1){   // Filters out any toggle buttons
      //int i = int((addr.charAt(9) )) - 0x30;   // returns the ASCII number so convert into a real number by subtracting 0x30
      desiredPosA  = int(theOscMessage.get(0).floatValue());     //  Puts button value into led[i]
      // Button values can be read by using led[0], led[1], led[2], etc.
    }
    else if(addr.indexOf("/1/servoB") !=-1){   // Filters out any toggle buttons
      //int i = int((addr.charAt(9) )) - 0x30;   // returns the ASCII number so convert into a real number by subtracting 0x30
      desiredPosB  = int(theOscMessage.get(0).floatValue());     //  Puts button value into led[i]
      // Button values can be read by using led[0], led[1], led[2], etc.
    }
}

void connect(String theIPaddress) {
  if (!myNetAddressList.contains(theIPaddress, outgoingPort)) {
       myNetAddressList.add(new NetAddress(theIPaddress, outgoingPort));
  }
}


void draw() {
 background(50);        // Sets the background to a dark grey, can be 0-255

  if(currentPosA != desiredPosA) {
    String pos = str(desiredPosA);
    println("Moving to position A " + pos);
    arduinoPort.write('a');
    arduinoPort.write(pos);
    arduinoPort.write('.');
    currentPosA = desiredPosA;

    redLED = int(map(desiredPosA, 0, 180, 0, 255));
    oscP5.send(new OscMessage("/1/ledA", new Object[]{redLED}), myNetAddressList);
  }

  if(currentPosB != desiredPosB) {
    String pos = str(desiredPosB);
    println("Moving to position B " + pos);
    arduinoPort.write('b');
    arduinoPort.write(pos);
    arduinoPort.write('.');
    currentPosB = desiredPosB;

    greenLED = int(map(desiredPosB, 0, 180, 0, 255));
    oscP5.send(new OscMessage("/1/ledB", new Object[]{greenLED}), myNetAddressList);
  }
  
  fill(redLED,0,0);            // Fill rectangle with redLED amount
  ellipse(50, 50, 50, 50);    // Created an ellipse at 50 pixels from the left...
                // 50 pixels from the top and a width of 50 and height of 50 pixels

  fill(0,greenLED,0);            // Fill rectangle with redLED amount
  ellipse(150, 50, 50, 50);    // Created an ellipse at 50 pixels from the left...
                // 50 pixels from the top and a width of 50 and height of 50 pixels
}

