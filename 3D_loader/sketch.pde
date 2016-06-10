import peasy.*;
PeasyCam cam;
Mesh s2;

void setup() {
  
  //Setting up size and rendering
  size(600, 600, P3D);
  perspective(PI/3.0, 1, 0.05, 12);

  String filePath = selectImage("Choose a .mesh file");
  if (filePath != null){
    s2 = new Mesh(filePath);
  }
  else{
    exit();
  }

  //Setting up camera
  cam = new PeasyCam(this, 2.5);
  cam.setMinimumDistance(0.56);
  cam.setMaximumDistance(5);
  cam.setWheelScale(0.025);
}

void draw() {
  background(0);
  lights();
  
  pushMatrix();
  s2.render();
  popMatrix();
}