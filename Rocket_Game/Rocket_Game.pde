import ddf.minim.*;

PFont font;

int numStars, numRockets;
float[] StarX;
float[] StarY;
float[] StarRadius;

ArrayList<Rocket> myRockets;
ArrayList<UFO> myUFOs;
ArrayList<PSys> myPSys;
ArrayList<UFOInvader> myUFOInvaders;

Trap myTrap;

int counter;

int score;
int lives;

int timeStamp;

boolean gameOver;

AudioPlayer player;
Minim minim;

boolean titleScreen;
boolean classicMode;
boolean invaderMode;
boolean sound;

PImage galaxy;

void setup() {
  size(700, 700);
  background(0);

  font = loadFont("Krungthep-48.vlw");

  counter = 0;

  lives = 10;

  numStars = 300;

  timeStamp = 0;

  StarX = new float[numStars];
  StarY = new float[numStars];
  StarRadius = new float[numStars];

  for (int i = 0; i<numStars; i++) {
    StarX[i] = random(0, 480);
    StarY[i] = random(0, 700);
    StarRadius[i] = random(2);
  }

  myRockets = new ArrayList<Rocket>();
  myUFOs = new ArrayList<UFO>();
  myPSys = new ArrayList<PSys>();
  myTrap = new Trap();
  myUFOInvaders = new ArrayList<UFOInvader>();
  gameOver = false; //for Invader Mode

    minim = new Minim(this);
  player = minim.loadFile("John Williams - Star Wars Main Theme (FULL).mp3", 2048);
  player.play();

  titleScreen = true;
  classicMode = false;
  invaderMode = false;
  sound = true;

  galaxy = loadImage("galaxy.jpg");
  galaxy.loadPixels();
}

void stop() {
  player.close();
  minim.stop();
  super.stop();
}

void drawStar(float x, float y, float radius, float opacity) {
  fill(215, 215, 255, opacity);
  noStroke();
  float cx, cy, theta, cradius;
  cx = cy = theta = cradius = 0;
  beginShape();
  for (int i=0; i<30; i++) {
    if (i%2 == 0) {
      cradius = radius;
    } else {
      cradius = 2*radius;
    }
    cx = x + cradius*cos(theta);
    cy = y + cradius*sin(theta);

    theta += TWO_PI/30;

    vertex(cx, cy);
  } 
  endShape();
}

void drawScore() {
  fill(255);
  textFont(font, 32);
  text("Score: " + score, 515, 50);
}

void drawLives() {
  fill(255);
  textFont(font, 32);
  text("Lives: " + lives, 515, 150);
}

void mousePressed() {
  if (titleScreen) {
    if (classicMode) {
      if (mouseX > 275 && mouseX < 425 && mouseY > 435 && mouseY < 510) { // GO! button for classicMode
        titleScreen = false;
        classicMode = true;
      }
      if (mouseX > 525 && mouseX < 675 && mouseY > 605 && mouseY < 680) { // MENU button for classicMode
        titleScreen = true;
        classicMode = false;
      }
    } else if (invaderMode) {
      if (mouseX > 275 && mouseX < 425 && mouseY > 435 && mouseY < 510) { // GO! button for invaderMode
        titleScreen = false;
        invaderMode = true;
      }
      if (mouseX > 525 && mouseX < 675 && mouseY > 605 && mouseY < 680) { // MENU button for invaderMode
        titleScreen = true;
        invaderMode = false;
      }
    } else {
      if (mouseX > 235 && mouseX < 465 && mouseY > 435 && mouseY < 510) { // CLASSIC button on title screen
        titleScreen = true;
        classicMode = true;
      }
      if (mouseX > 235 && mouseX < 465 && mouseY > 535 && mouseY < 610) { // INVADER button on title screen
        titleScreen = true;
        invaderMode = true;
      }
    }
  } else if (classicMode) {
    if (lives <= 0) {
      if (mouseX > 275 && mouseX < 425 && mouseY > 435 && mouseY < 510) {
        counter = 0;
        score = 0;
        timeStamp = 0;
        lives = 10;
        myTrap.left = 0;
        for (int i = myUFOs.size () - 1; i >= 0; i--) {
          myUFOs.remove(i);
        }
        for (int i = myPSys.size () - 1; i >= 0; i--) {
          myPSys.remove(i);
        }
      }
      if (mouseX > 525 && mouseX < 675 && mouseY > 605 && mouseY < 680) {
        frameCount = 0;
        titleScreen = true;
        classicMode = false;
        counter = 0;
        score = 0;
        timeStamp = 0;
        lives = 10;
        myTrap.left = 0;
        for (int i = myUFOs.size () - 1; i >= 0; i--) {
          myUFOs.remove(i);
        }
        for (int i = myRockets.size () - 1; i >= 0; i--) {
          myRockets.remove(i);
        }
        for (int i = myPSys.size () - 1; i >= 0; i--) {
          myPSys.remove(i);
        }
      }
    } else {
      if (mouseY > 4 * 700 / 5 && mouseX < 500) {
        myRockets.add(new Rocket());
        myRockets.get(counter).hasPressed = true;
        myRockets.get(counter).moveRocket(mouseX, mouseY);
        counter++;
      }
      if (mouseX > 525 && mouseX < 675 && mouseY > 605 && mouseY < 680) {
        frameCount = 0;
        titleScreen = true;
        classicMode = false;
        counter = 0;
        score = 0;
        timeStamp = 0;
        lives = 10;
        myTrap.left = 0;
        for (int i = myUFOs.size () - 1; i >= 0; i--) {
          myUFOs.remove(i);
        }
        for (int i = myRockets.size () - 1; i >= 0; i--) {
          myRockets.remove(i);
        }
        for (int i = myPSys.size () - 1; i >= 0; i--) {
          myPSys.remove(i);
        }
      }
    }
  } else if (invaderMode) { 
    if (gameOver) {
      if (mouseX > 275 && mouseX < 425 && mouseY > 435 && mouseY < 510) {
        gameOver = false;
        counter = 0;
        score = 0;
        timeStamp = 0;
        lives = 10;
        for (int i = myUFOInvaders.size () - 1; i >= 0; i--) {
          myUFOInvaders.remove(i);
        }
        for (int i = myPSys.size () - 1; i >= 0; i--) {
          myPSys.remove(i);
        }
      }
      if (mouseX > 525 && mouseX < 675 && mouseY > 605 && mouseY < 680) {
        frameCount = 0;
        titleScreen = true;
        invaderMode = false;
        gameOver = false;
        score = 0;
        counter = 0;
        timeStamp = 0;
        lives = 10;
        for (int i = myRockets.size () - 1; i >= 0; i--) {
          myRockets.remove(i);
        }
        for (int i = myUFOInvaders.size () - 1; i >= 0; i--) {
          myUFOInvaders.remove(i);
        }
        for (int i = myPSys.size () - 1; i >= 0; i--) {
          myPSys.remove(i);
        }
      }
    } else {
      if (mouseY > 4 * 700 / 5 && mouseX < 500) {
        myRockets.add(new Rocket());
        myRockets.get(counter).hasPressed = true;
        myRockets.get(counter).moveRocket(mouseX, mouseY);
        counter++;
        score--;
      }
      if (mouseX > 525 && mouseX < 675 && mouseY > 605 && mouseY < 680) {
        frameCount = 0;
        titleScreen = true;
        invaderMode = false;
        gameOver = false;
        score = 0;
        counter = 0;
        timeStamp = 0;
        lives = 10;
        for (int i = myRockets.size () - 1; i >= 0; i--) {
          myRockets.remove(i);
        }
        for (int i = myUFOInvaders.size () - 1; i >= 0; i--) {
          myUFOInvaders.remove(i);
        }
        for (int i = myPSys.size () - 1; i >= 0; i--) {
          myPSys.remove(i);
        }
      }
    }
  }

  if (mouseX > 600 && mouseX < 675 && mouseY > 505 && mouseY < 580) { // Sound button
    sound = !sound;
    if (sound) {
      player.unmute();
    } else {
      player.mute();
    }
  }
}

void draw() {
  background(0);

  if (titleScreen) { // titleScreen
    background(12, 12, 12);
    galaxy.updatePixels();
    image(galaxy, 0, 0);

    if (frameCount < 100) {
      pushMatrix();
      translate(width/2, 370);
      scale(14);
      rotate(PI/4);
      translate(-9 - (5 - 0.05*frameCount), 400 - 4*frameCount);
      noStroke();
      fill(random(150, 255), random(125), 0);
      ellipse(0, 0, random(8, 10), random(13, 15));
      fill(255);
      beginShape();
      vertex(-6, -4);
      vertex(6, -4);
      vertex(6, -20);
      vertex(0, -26);
      vertex(-6, -20);
      endShape();
      quad(-6, -4, 6, -4, 10, 0, -10, 0);
      popMatrix();
    } else {
      pushMatrix();
      translate(width/2, 370);
      scale(14);
      rotate(PI/4);
      translate(-9, 0);
      noStroke();
      fill(random(150, 255), random(125), 0);
      ellipse(0, 0, random(8, 10), random(13, 15));
      fill(255);
      beginShape();
      vertex(-6, -4);
      vertex(6, -4);
      vertex(6, -20);
      vertex(0, -26);
      vertex(-6, -20);
      endShape();
      quad(-6, -4, 6, -4, 10, 0, -10, 0);
      popMatrix();
    }

    fill(255, 0, 0);
    textFont(font, 56);
    text("MEGA", 265, 100);

    textFont(font, 86);
    text("ROCKET", 179, 175);

    textFont(font, 56);
    text("BLASTER", 231, 228);

    if (classicMode) { // titleScreen && classicMode
      fill(0);
      stroke(255);
      rect(150, 150, 400, 400, 30);

      fill(255);
      textFont(font, 42);
      text("CLASSIC MODE", 193, 217);

      textFont(font, 16);
      text("Due to heavy asteroid traffic, the alien population has asked you to do some damage on the largest rock that blocks the most used intergalactic highway. Don't catch the UFO's in the crossfire while launching missiles from below the green fire zone. Use your mouse. Do some damage.", 200, 245, 300, 380);
      if (mouseX > 275 && mouseX < 425 && mouseY > 435 && mouseY < 510) { // GO! button
        fill(255, 0, 0);
        stroke(255);
        strokeWeight(5);
        rect(275, 435, 150, 75, 15);
        fill(255);
        textFont(font, 35);
        text("GO!", 320, 485);
      } else {
        fill(0, 175, 0);
        stroke(255);
        strokeWeight(5);
        rect(275, 435, 150, 75, 15);
        fill(255);
        textFont(font, 35);
        text("GO!", 320, 485);
      }

      if (mouseX > 525 && mouseX < 675 && mouseY > 605 && mouseY < 680) { // MENU button
        fill(255, 0, 0);
        stroke(255);
        strokeWeight(5);
        rect(525, 605, 150, 75, 15);
        fill(255);
        textFont(font, 35);
        text("MENU", 549, 655);
      } else {
        fill(#178DFF);
        stroke(255);
        strokeWeight(5);
        rect(525, 605, 150, 75, 15);
        fill(255);
        textFont(font, 35);
        text("MENU", 549, 655);
      }
    } else if (invaderMode) { // titleScreen && invaderMode
      fill(0);
      stroke(255);
      rect(150, 150, 400, 400, 30);

      fill(255);
      textFont(font, 42);
      text("INVADER MODE", 193, 217);

      textFont(font, 16);
      text("The Alien UFOs have been infected by a super scary zombie-ebola-H1N1 disease.  We need to destroy their ships before they break through the green boundary or we will all be super sad.  Click below the green line to fire rockets. Earn 2 points for each UFO hit, lose 1 for using a rocket.", 200, 235, 300, 380);
      if (mouseX > 275 && mouseX < 425 && mouseY > 435 && mouseY < 510) { // GO! button
        fill(255, 0, 0);
        stroke(255);
        strokeWeight(5);
        rect(275, 435, 150, 75, 15);
        fill(255);
        textFont(font, 35);
        text("GO!", 320, 485);
      } else {
        fill(0, 175, 0);
        stroke(255);
        strokeWeight(5);
        rect(275, 435, 150, 75, 15);
        fill(255);
        textFont(font, 35);
        text("GO!", 320, 485);
      }

      if (mouseX > 525 && mouseX < 675 && mouseY > 605 && mouseY < 680) { // MENU button
        fill(255, 0, 0);
        stroke(255);
        strokeWeight(5);
        rect(525, 605, 150, 75, 15);
        fill(255);
        textFont(font, 35);
        text("MENU", 549, 655);
      } else {
        fill(#178DFF);
        stroke(255);
        strokeWeight(5);
        rect(525, 605, 150, 75, 15);
        fill(255);
        textFont(font, 35);
        text("MENU", 549, 655);
      }
    } else { // titleScreen && !classicMode && !invaderMode
      if (mouseX > 235 && mouseX < 465 && mouseY > 435 && mouseY < 510) {
        fill(255, 0, 0);
        stroke(255);
        strokeWeight(5);
        rect(235, 435, 230, 75, 15);
        fill(255);
        textFont(font, 35);
        text("CLASSIC", 278, 485);
      } else {
        fill(0, 175, 0);
        stroke(255);
        strokeWeight(5);
        rect(235, 435, 230, 75, 15);
        fill(255);
        textFont(font, 35);
        text("CLASSIC", 278, 485);
      }
      if (mouseX > 235 && mouseX < 465 && mouseY > 535 && mouseY < 610) {
        fill(255, 0, 0);
        stroke(255);
        strokeWeight(5);
        rect(235, 535, 230, 75, 15);
        fill(255);
        textFont(font, 35);
        text("INVADER", 272, 585);
      } else {
        fill(0, 175, 0);
        stroke(255);
        strokeWeight(5);
        rect(235, 535, 230, 75, 15);
        fill(255);
        textFont(font, 35);
        text("INVADER", 272, 585);
      }
    }
  } else { 
    if (classicMode) { // !titleScreen && classicMode
      for (int i = 0; i<numStars; i++) {
        drawStar(StarX[i], StarY[i], StarRadius[i], random(50, 120));
      }

      for (int i = 0; i < myRockets.size (); i++) {
        myRockets.get(i).drawRocket();
        myRockets.get(i).update(1.0);
        if (myRockets.get(i).checkIfScored()) {
          myPSys.add(new PSys(100, new PVector(myRockets.get(i).x, myRockets.get(i).y, 0), 1, myRockets.get(i).rocketType));
          myRockets.remove(i); 
          counter--;
          myUFOs.add(new UFO());
        }
      }

      for (int i = myRockets.size ()-1; i >= 0; i--) {
        for (int j = myUFOs.size () - 1; j >= 0; j--) {
          if (myRockets.get(i).checkIfCrashed(myUFOs.get(j))) {
            myPSys.add(new PSys(100, new PVector(myUFOs.get(j).x, myUFOs.get(j).y, 0), 0, myRockets.get(i).rocketType));
            myRockets.remove(i);
            counter--;
            myUFOs.remove(j);
            i--;
            j--;
            break;
          }
        }
      }

      for (int i = 0; i < myPSys.size (); i++) {
        myPSys.get(i).run();
      }

      for (int i = 0; i < myUFOs.size (); i++) {
        myUFOs.get(i).drawUFO();
        myUFOs.get(i).update(1.0);
      }

      myTrap.drawTrap();
      myTrap.update(1.0);

      drawScore();
      drawLives();

      stroke(0, 229, 17, 127);
      strokeWeight(10);
      line(0, 4 * 700 / 5, 500, 4 * 700 / 5);
      stroke(255, 0, 0);
      line(500, 0, 500, 700);

      if (mouseX > 525 && mouseX < 675 && mouseY > 605 && mouseY < 680) {
        fill(255, 0, 0);
        stroke(255);
        strokeWeight(5);
        rect(525, 605, 150, 75, 15);
        fill(255);
        textFont(font, 35);
        text("MENU", 549, 655);
      } else {
        fill(#178DFF);
        stroke(255);
        strokeWeight(5);
        rect(525, 605, 150, 75, 15);
        fill(255);
        textFont(font, 35);
        text("MENU", 549, 655);
      }

      if (lives <= 0) {
        for (int i = myRockets.size () - 1; i >= 0; i--) {
          myRockets.remove(i);
        }

        fill(0);
        stroke(255);
        rect(150, 150, 400, 400, 30);

        fill(255);
        textFont(font, 42);
        text("GAME OVER", 225, 217);

        textFont(font, 35);
        text("Score: " + score, 265, 300);

        fill(0, 175, 0);
        textFont(font, 30);
        text("Save the aliens again?", 167, 400);

        if (mouseX > 275 && mouseX < 425 && mouseY > 435 && mouseY < 510) {
          fill(255, 0, 0);
          strokeWeight(5);
          rect(275, 435, 150, 75, 15);
          fill(255);
          textFont(font, 35);
          text("GO!", 320, 485);
        } else {
          strokeWeight(5);
          rect(275, 435, 150, 75, 15);
          fill(255);
          textFont(font, 35);
          text("GO!", 320, 485);
        }
      }
    }
    if (invaderMode) {
      for (int i = 0; i<numStars; i++) {
        drawStar(StarX[i], StarY[i], StarRadius[i], random(50, 120));
      }

      for (int i = 0; i < myRockets.size (); i++) {
        myRockets.get(i).drawRocket();
        myRockets.get(i).update(1.0);
      }

      for (int i = myRockets.size ()-1; i >= 0; i--) {
        for (int j = myUFOInvaders.size () - 1; j >= 0; j--) {
          if (myRockets.get(i).checkIfCrashed(myUFOInvaders.get(j))) {
            myPSys.add(new PSys(100, new PVector(myUFOInvaders.get(j).x, myUFOInvaders.get(j).y, 0), 0, myRockets.get(i).rocketType));
            myRockets.remove(i);
            counter--;
            myUFOInvaders.remove(j);
            i--;
            j--;
            score += 2;
            break;
          }
        }
      }

      for (int i = 0; i < myPSys.size (); i++) {
        myPSys.get(i).run();
      }

      for (int i = 0; i < myUFOInvaders.size (); i++) {
        myUFOInvaders.get(i).drawUFO();
        myUFOInvaders.get(i).update(1.0);
      }

      if (score < 10) {
        if (timeStamp % 95 == 0) {
          myUFOInvaders.add(new UFOInvader());
        }
      } else if (score < 20) {
        if (timeStamp % 70 == 0) {
          myUFOInvaders.add(new UFOInvader());
        }
      } else if (score < 30) {
        if (timeStamp % 45 == 0) {
          myUFOInvaders.add(new UFOInvader());
        }
      } else if (score < 100) {
        if (timeStamp % 20 == 0) {
          myUFOInvaders.add(new UFOInvader());
        }
      } else {
        myUFOInvaders.add(new UFOInvader());
      }

      timeStamp++;

      drawScore();

      stroke(0, 229, 17, 127);
      strokeWeight(10);
      line(0, 4 * 700 / 5, 500, 4 * 700 / 5);
      stroke(255, 0, 0);
      line(500, 0, 500, 700);

      if (mouseX > 525 && mouseX < 675 && mouseY > 605 && mouseY < 680) {
        fill(255, 0, 0);
        stroke(255);
        strokeWeight(5);
        rect(525, 605, 150, 75, 15);
        fill(255);
        textFont(font, 35);
        text("MENU", 549, 655);
      } else {
        fill(#178DFF);
        stroke(255);
        strokeWeight(5);
        rect(525, 605, 150, 75, 15);
        fill(255);
        textFont(font, 35);
        text("MENU", 549, 655);
      }

      if (gameOver) {
        for (int i = myRockets.size () - 1; i >= 0; i--) {
          myRockets.remove(i);
        }

        fill(0);
        stroke(255);
        rect(150, 150, 400, 400, 30);

        fill(255);
        textFont(font, 42);
        text("GAME OVER", 225, 217);

        textFont(font, 35);
        text("Score: " + score, 265, 300);

        fill(0, 175, 0);
        textFont(font, 30);
        text("Attempt to save yourself again?", 225, 335, 300, 450);

        if (mouseX > 275 && mouseX < 425 && mouseY > 435 && mouseY < 510) {
          fill(255, 0, 0);
          strokeWeight(5);
          rect(275, 435, 150, 75, 15);
          fill(255);
          textFont(font, 35);
          text("GO!", 320, 485);
        } else {
          strokeWeight(5);
          rect(275, 435, 150, 75, 15);
          fill(255);
          textFont(font, 35);
          text("GO!", 320, 485);
        }
      } else {
        for (int i = 0; i < myUFOInvaders.size (); i++) {
          if (myUFOInvaders.get(i).y >= 4 * 700 / 5) {
            gameOver = true;
          }
        }
      }
    }
  }

  if (mouseX > 600 && mouseX < 675 && mouseY > 505 && mouseY < 580) { // Sound button
    fill(255, 0, 0);
    stroke(255);
    strokeWeight(5);
    rect(600, 505, 75, 75, 15);
    fill(255);
    textFont(font, 35);
  } else {
    fill(#178DFF);
    stroke(255);
    strokeWeight(5);
    rect(600, 505, 75, 75, 15);
    fill(255);
    textFont(font, 35);
  }
}

class Rocket {
  float x, y, velY;
  boolean hasPressed;
  int rocketType;

  Rocket() {
    this.x = 0;
    this.y = height + 30;
    hasPressed = false;
    if (score < 10) {
      rocketType = 0;
      velY = 1.0;
    } else if (score < 20) {
      rocketType = 1;
      velY = 1.1;
    } else if (score < 30) {
      rocketType = 2;
      velY = 1.2;
    } else {
      rocketType = 3;
      velY = 1.3;
    }
  }

  void moveRocket(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void drawRocket() {
    if (rocketType == 0) {
      pushMatrix();
      translate(x, y);
      noStroke();
      fill(random(150, 255), random(125), 0);
      ellipse(0, 0, random(8, 10), random(13, 15));
      fill(255);
      beginShape();
      vertex(-6, -4);
      vertex(6, -4);
      vertex(6, -20);
      vertex(0, -26);
      vertex(-6, -20);
      endShape();
      quad(-6, -4, 6, -4, 10, 0, -10, 0);
      popMatrix();
    } else if (rocketType == 1) {
      pushMatrix();
      translate(x, y);
      noStroke();
      fill(255);
      quad(-6, -4, 6, -4, 10, 0, -10, 0);
      fill(random(150, 255), random(125), 0);
      ellipse(0, 0, random(4, 6), random(13, 15));
      fill(0, 0, 255);
      beginShape();
      vertex(-4, 0);
      vertex(4, 0);
      vertex(4, -20);
      vertex(0, -26);
      vertex(-4, -20);
      endShape();
      popMatrix();
    } else if (rocketType == 2) {
      pushMatrix();
      translate(x, y);
      noStroke();
      fill(255);
      quad(-5, -16, 5, -16, 10, 0, -10, 0);
      fill(random(150, 255), random(125), 0);
      ellipse(0, 0, random(6, 8), random(13, 15));
      fill(0, 255, 0);
      beginShape();
      vertex(-5, 0);
      vertex(5, 0);
      vertex(5, -20);
      vertex(0, -26);
      vertex(-5, -20);
      endShape();
      fill(255);
      triangle(3, -12, 0, -26, -3, -12);
      popMatrix();
    } else if (rocketType == 3) {
      pushMatrix();
      translate(x, y);
      noStroke();
      fill(random(150, 255), random(125), 0);
      ellipse(0, 0, random(8, 10), random(13, 15));
      fill(random(100, 255), random(100, 255), random(100, 255));
      beginShape();
      vertex(-6, -4);
      vertex(6, -4);
      vertex(6, -20);
      vertex(0, -26);
      vertex(-6, -20);
      endShape();
      quad(-6, -4, 6, -4, 10, 0, -10, 0);
      popMatrix();
    }
  }

  boolean checkIfScored() {
    boolean retval = false;
    if (y > 0 && y < 25 && x >= myTrap.left && x <= (myTrap.left + myTrap.size)) {
      score++;
      retval = true;
    }
    return retval;
  }

  boolean checkIfCrashed(UFO myUFO) {
    boolean retval = false;
    if (y > (myUFO.y - 6) && y < (myUFO.y + 6) && x > (myUFO.x - 40) && x < (myUFO.x + 40)) {
      lives--;
      retval = true;
    }
    return retval;
  }

  boolean checkIfCrashed(UFOInvader myUFOInvader) {
    boolean retval = false;
    if (y > (myUFOInvader.y - 6) && y < (myUFOInvader.y + 6) && x > (myUFOInvader.x - 40) && x < (myUFOInvader.x + 40)) {
      retval = true;
    }
    return retval;
  }

  void update(float time) {
    if (hasPressed) {
      y -= time * velY;
      velY *= 1.02;
    }
  }
}

class Trap {
  float size, left;
  boolean direction = true;

  Trap() {
    left = 0;
    size = 500/5;
  }

  void drawTrap() {
    stroke(50);
    strokeWeight(3);
    fill(#747474);
    ellipse(left + size/2, 0, size, 50);
    stroke(50);
    strokeWeight(3);
    ellipse(left + 10, 10, 10, 10);
    ellipse(left + 50, 20, 10, 10);
    ellipse(left + 65, 13, 10, 10); 
    ellipse(left + 86, 5, 10, 10);
  }

  void update(float time) {
    if ((left + size) == 500) {
      direction = false;
    }

    if (left == 0) {
      direction = true;
    }

    if (direction) {
      left += time;
    } else {
      left -= time;
    }
  }
}

class UFO {
  float x, y, vx;
  boolean direction;

  UFO() {
    x = random(32, 468);
    y = random(50, 560);
    vx = random(1, 1.5);
    float temp = random(100);
    if (temp < 50) {
      direction = true;
    } else {
      direction = false;
    }
  }

  void drawUFO() {
    noStroke();
    pushMatrix();
    translate(x, y);
    scale(.8);
    translate(-x, -y);
    fill(#B4B4B4);
    arc(x, y, 40, 30, 0, PI);

    fill(#838383);
    ellipse(x, y, 80, 20);

    fill(#B4B4B4);
    arc(x, y - 5, 40, 30, -PI, 0);

    fill(#277CF0);
    for (int i = 0; i < 8; i++) {
      ellipse(x - 35 + 10*i, y, 3, 3);
    }
    popMatrix();
  }

  void update(float time) {
    if (x > 468) {
      direction = false;
    }

    if (x < 32) {
      direction = true;
    }

    if (direction) {
      x += vx * time;
    } else {
      x -= vx * time;
    }
  }
}

class UFOInvader {
  float x, y, vy;
  boolean direction;

  UFOInvader() {
    x = random(32, 468);
    y = -30;
    vy = random(1.5, 2.5);
  }

  void drawUFO() {
    noStroke();
    pushMatrix();
    translate(x, y);
    scale(.8);
    translate(-x, -y);
    fill(#B4B4B4);
    arc(x, y, 40, 30, 0, PI);

    fill(#838383);
    ellipse(x, y, 80, 20);

    fill(#B4B4B4);
    arc(x, y - 5, 40, 30, -PI, 0);

    fill(#277CF0);
    for (int i = 0; i < 8; i++) {
      ellipse(x - 35 + 10*i, y, 3, 3);
    }
    popMatrix();
  }

  void update(float time) {
    y += vy * time;
  }
}

class Particle {

  PVector loc;
  PVector vel;
  PVector accel;
  float r;
  float life;
  PVector pcolor;
  int particleType;

  Particle(PVector start, int particleType, int rocketType) {
    if (particleType == 0) {
      vel = new PVector(random(-2, 2), random(-6, 0), 0);
      loc = start.get();
      r = 4.0;
      life = 40;
    } else if (particleType == 1) {
      vel = new PVector(random(-2, 2), random(6), 0);
      loc = start.get();
      r = 4.0;
      life = 20;
    }
    if (rocketType == 0) {
      pcolor = new PVector(random(150, 255), random(125), 0);
    } else if (rocketType == 1) {
      pcolor = new PVector(0, random(255), 255);
    } else if (rocketType == 2) {
      pcolor = new PVector(0, 255, random(255));
    } else if (rocketType == 3) {
      pcolor = new PVector(random(100, 255), random(100, 255), random(100, 255));
    }
  }  

  void run() {
    updateP();
    renderP();
  }

  void updateP() {
    loc.add(vel);
    life -= 1.0;
  }

  void renderP() {
    if (loc.x < 500) {
      pushMatrix();
      ellipseMode(CENTER);
      noStroke();
      fill(pcolor.x, pcolor.y, pcolor.z);
      translate(loc.x, loc.y);
      ellipse(0, 0, r, r);
      popMatrix();
    }
  }

  boolean alive() {
    if (life <= 0.0) {
      return false;
    } else {
      return true;
    }
  }
} 

class PSys {

  ArrayList particles;
  PVector source;

  PSys(int num, PVector init_loc, int particleType, int rocketType) {
    particles = new ArrayList();
    source = init_loc.get();
    for (int i=0; i < num; i++) {
      particles.add(new Particle(source, particleType, rocketType));
    }
  }

  void run() {
    for (int i=particles.size ()-1; i >=0; i--) {
      Particle p = (Particle) particles.get(i);
      p.run();
      if ( !p.alive()) {
        particles.remove(i);
      }
    }
  }

  boolean dead() {
    if (particles.isEmpty() ) {
      return true;
    } else {
      return false;
    }
  }
}

