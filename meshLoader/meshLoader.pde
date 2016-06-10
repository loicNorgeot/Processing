import peasy.*;
PeasyCam cam;
Mesh s2;
boolean lights = true, dark = true, persp=true;
color backgroundColor = color(0);

void setup() {
  fullScreen(P3D);
  //Setting up size and rendering
  //size(1200, 800, P3D);
  
  perspective(PI/3.0, (float)width/(float)height, 0.05, 12);

  /*
  String filePath = selectImage("Choose a .mesh file");
  if (filePath != null){
    s2 = new Mesh(filePath);
  }
  else{
    exit();
  }
  */
  s2 = new Mesh("/home/norgeot/Bureau/Orange/NumeRO/models/2_FINE_REMESH/257.o.mesh");
  //s2 = new Mesh("/home/norgeot/Bureau/Orange/NumeRO/models/1_MESH/257.mesh");
  
  //Setting up camera
  cam = new PeasyCam(this, 2.5);
  cam.setMinimumDistance(0.56);
  cam.setMaximumDistance(5);
  cam.setWheelScale(0.025);
}

void draw() {
  background(backgroundColor);
  if(lights)
    lights();
  
  pushMatrix();
  s2.render();
  popMatrix();
}

void keyPressed(){
  if(key=='l'){
    lights = !lights;
    if(!lights)
      s2.geometry.setStroke(true);
    else
      s2.geometry.setStroke(false);
  }
  if(key=='b'){
    dark = !dark;
    if(!dark){
      s2.geometry.setStroke(color(0,75));
      backgroundColor = color(255);
    }
    else{
      s2.geometry.setStroke(color(255,75));
      backgroundColor = color(0);
    }
  }
  if(key=='f'){
    persp=!persp;
    if (!persp)
      ortho(0, width, 0, height);
    else
      perspective(PI/3.0, (float)width/(float)height, 0.05, 12);
  }
}