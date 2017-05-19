Spot foo[] = new Spot[75]; 

import SimpleOpenNI.*;
SimpleOpenNI  context;


float zoomF = 0.5f;
float rotX = radians(0);
float rotY = radians(0);
int sizeX = 1200;
int sizeY = 800;

int r1 = 170;
int g1 = 201;
int b1 = 156;
int r2 = 0;
int g2 = 199;
int b2 = 226;
int a = 150;
int backc = 188;
float BARhite = 0.0769;
int flag =  -1 ;

int maxRadius;
float interfaceW;
float interfaceH;

//float barwidth;
//float barheight;
float topbarW;
float topbarH;
float speed;

// take hand pos
PVector left = new PVector();
PVector right = new PVector();
float ly;
float lly = 0.0;
float lx;
float llx = 0.0;
float ry;
float lry = 0.0;
float rx;
float lrx = 0.0;
int X=0;


void setup(){
  context = new SimpleOpenNI(this);
  context.enableDepth();
  context.enableUser(); 
  
  size(sizeX,sizeY);
  
  perspective(radians(45), float(width)/float(height), 10, 150000);
  background(0);
  frameRate(100);
  
  // barwidth = 0.04;
  // barheight = 0.5;
  // interfaceW = width;
  // interfaceH = BARhite*height;
  // topbarW = barheight*width;
  // topbarH = barwidth*height;
  maxRadius = 75;
  speed = 3.0; // from 0-1
 
  // fill(255,0,0);
  // rect(0,0,0.02*width, interfaceH);
 
  // Whenever you want to do something to all your spots you need to iterate through the array:
  for(int i=0;i<foo.length;i++) {
    // create a random colour.  By limiting r and g and setting a minimum for b we should get a selection of blues
    // while I adjusted color for the circles later, i couldn't delete this area without losing it all
   int r = (int) random(100);
   int g = (int) random(100);
   int b = 155 + (int) random(100);
   color colour = color(r,g,b);
   // create the Spot objects:
   foo[i] = new Spot(random(2*width),0,random(maxRadius), colour);
   }
   
   smooth();
}

//BACKGROUND VALUE CONTROL AND DRAW
void draw(){
    
  context.update();
  loadPixels();
  updatePixels();
  
  // draw the kinect cam
  context.drawCamFrustum();
  
  // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);
  stroke(255);
  strokeWeight(2);
  line(-width/2, 0, width/2, 0);
  line(0, -height/2, 0, height/2);
  background(backc);
  
  int[]   depthMap = context.depthMap();
  int[]   userMap = context.userMap();
  int     steps = 3;
  int     index;
  PVector realWorldPoint;
  
  translate(0,0,-1000);

  // draw the pointcloud
  beginShape(POINTS);
  for(int y=0;y < context.depthHeight();y+=steps){
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      if(depthMap[index] > 0){ 
        // draw the projected point
        realWorldPoint = context.depthMapRealWorld()[index];
        if(userMap[index] != 0) {
          stroke(255, 0, 0);       
          point(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);
        }
      }
    } 
  } 
  endShape();  
    
  int[] userList = context.getUsers();
  for(int i=0; i<userList.length; i++){
      // calc speed
      speed += 0.05;
      speed *= 0.95;
    if(context.isTrackingSkeleton(userList[i])){
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND, left);
      context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND, right);
      
      // get hands positions
      ly = (left.y)/2 + 150;
      lx = left.x;
      ry = (right.y)/2 + 150;
      rx = right.x;
      
      // calc speed
      speed += (calcSpeed(lx, ly, llx, lly) + calcSpeed(rx, ry, lry, lrx))/1000;
      
      // get last hands positions
      lly = ly;
      llx = lx;
      lry = ry;
      lrx = rx;
      
      if (left.dist(right) < 80){
        mouseClicked();
      }
      
      println("left_hand X: " +lx + " Y: "+ ly);
      println("right_hand X: "+ rx+ " Y: " + ry);
    }
  }
    
    if (flag == 0) {
      X = int(rx);
    } else {
      X = int(width - rx);
    }
    
    //begin "if mouse gets near edges do controls of inner and outer circles
    if (ly > ((1-BARhite)*height)) {
      backc = ((255*X)/width); //change background shade
    }
 
    //red TOP -- INNER CIRCLE
    if (ly  < BARhite*height) { //outer circle, red control
      r2 = ((255*X)/width);
    }
     
    //blue TOP -- OUT CIRCLE
    if (ly > (BARhite*height) && ly < (2*BARhite*height)) {
      b1 = ((255*X)/width);
    } 
        
   //green TOP -- INNER CIRCLE
   if (ly  > (2*BARhite*height) && ly < (3*BARhite*height)) {
     g2 = ((255*X)/width);
   }
     
  //red SECOND -- OUTER CIRCLE
   if (ly  > (3*BARhite*height) && ly < (4*BARhite*height)) { //outer circle, red control
     r1 = ((255*X)/width);
   }

   //blue SECOND -- INNER CIRCLE
   if (ly  > (4*BARhite*height) && ly < (5*BARhite*height)) {
     b2 = ((255*X)/width);
   }
   
   //green SECOND -- INNER CIRCLE
   if (ry > (5*BARhite*height) && ry < (6*BARhite*height)) {
     g2 = ((255*X)/width);
   }   
     
  //red THIRD -- OUTER CIRCLE
   if (ry > (6*BARhite*height) && ry < (7*BARhite*height)) { //outer circle, red control
     backc = ((255*X)/width); //change background shade
   }
    
   //blue SECOND -- INNER CIRCLE
   if (ry > (7*BARhite*height) && ry < (8*BARhite*height)) {
     b2 = ((255*X)/width);
   }    
     
   //green TIHRD -- OUTER CIRCLE
   if (ry > (8*BARhite*height) && ry < (9*BARhite*height)) {
     g1 = ((255*X)/width);
   }

    //red 4th -- INNER CIRCLE
    if (ry > (9*BARhite*height) && ry < (10*BARhite*height)) { //outer circle, red control
      r2 = ((255*X)/width);
    }
    
   //blue 4th -- OUTER CIRCLE
   if (ry > (10*BARhite*height) && ry < (11*BARhite*height)) {
     b1 = ((255*X)/width);
   }
  
   //green 4th -- INNER CIRCLE
   if (ry > (11*BARhite*height) && ry < (12*BARhite*height)) {
     g2 = ((255*X)/width);
   }   
         
  // chage spots direction
  for (int i =0; i<foo.length; i++) {
    if ((lx + rx)> (llx + lrx)) {
      foo[i].posite();
    } else if (mouseX < llx){
      foo[i].negate();
    }
   }

  // display the spots:
  for(int i=0;i<foo.length;i++) {
    foo[i].display();
  }
  
  println("mouse pos X: "+ mouseX + "Y: " + mouseY);
}

void onNewUser(SimpleOpenNI curContext, int userId){
  context.startTrackingSkeleton(userId);
}

void mouseClicked() {
   if (flag == 0) {
     flag = -1;
     println(flag);
   } else {
     flag = 0;
     println(flag);
   }
}

float calcSpeed(float X, float Y, float x, float y) {
  float speed = 0;
  speed = sqrt(sq((X - x)) + sq((Y - y)));
  return speed; 
}

class Spot {
 float x, y, radius;
 float vx,vy; // to store velocities
 color colour;

 Spot(float xpos, float ypos, float r, color c) {
   x = xpos;
   y = ypos;
   vx = random(-1,1);  // create small random horizontal velocity
   vy = 1 + random(3);  // set a vertical velocity
   radius = r;
   colour = c;
 }
 
 void posite() {
   vx = abs(vx);
 }
 
 void negate() {
   vx = -abs(vx);
 }
  
 void display() {
//   println("particle pos X:"+ x + " Y :" + y);
   color from = color(r1,g1,b1,a);
   color to = color(r2,g2,b2,a);
   color interA = lerpColor(from, to, .25);
   color interB = lerpColor(from, to, .5);
   color interC = lerpColor(from, to, .75);
   
   noStroke();
   
   fill(from);
   ellipse(x, y, radius*2.8, radius*2.8);

   fill(interA);
   ellipse(x, y, radius*2.6, radius*2.6);
    
   fill(interB);
   ellipse(x, y, radius*2.4, radius*2.4);

   fill(interC);
   ellipse(x, y, radius*2.2, radius*2.2);
   
   fill(to);
   ellipse(x, y, radius*3.0, radius*3.0);
   x += 2*vx*speed;
   y += vy*speed; 
      
   // If they go beyond the bottom of the screen one option is to simply place them back at the top:
   if(y > height *1.5  + (maxRadius * 5)) {
     // by resetting all these it will look like a different ball
     int r = (int) random(100);
     int g = (int) random(100);
     int b = 155 + (int) random(100);
     colour = color(r,g,b);
     radius = 1+random(30);
     vx = random(-1,1);  // create small random horizontal velocity
     vy = 1 + random(3);  // set a vertical velocity
     x = random(2*width);
     y = -(maxRadius * 5);
  }
 }
}  


