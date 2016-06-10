import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.SwingUtilities;

class Mesh { 
  int nV = 0, nT = 0;
  float[][] bbBox = {{1000,-1000}, {1000,-1000}, {1000,-1000}};
  float[][] verts;
  int[][]   faces;
  float[]   values;
  color[]   colors;
  PShape geometry;
  
  Mesh(String filename){
    //Reading file in verts and faces
    boolean vFound = false, tFound = false;
    int     vBegin = 0,     tBegin = 0;
    
    String LINES[] = loadStrings(filename);
    for (int i = 0; i < LINES.length; i++) {
      String[] s = LINES[i].split("\\s+");
      
      if (vFound && (i>=vBegin) && (i<vBegin+nV)){
        verts[i-vBegin] = new float[]{float(s[0]),float(s[1]),float(s[2])};
      }
  
      if (tFound && i >= tBegin && i < tBegin + nT){
        faces[i-tBegin] = new int[]{int(s[0]),int(s[1]),int(s[2])};
      }
        
      if (LINES[i].contains("ertice") && vFound==false) {
        vBegin = i+2;
        vFound = true;
        nV = int(LINES[i+1]);
        verts = new float[nV][3];
      }
      if (LINES[i].contains("riangle") && tFound==false) {
        tBegin = i+2;
        tFound = true;
        nT = int(float(LINES[i+1]));
        faces = new int[nT][3];
      }
    }
    
    readSol(filename);
    createGeometry();
    scaleAndTranslate();
    
    println("Number of vertices = ", nV);
    println("Number of faces = ",    nT);
    
  }
  
  void readSol(String filename){
    String solFile = filename.substring(0, filename.lastIndexOf('.')) + ".sol";
    File file = new File(solFile);
    if(file.exists()){
      println("Found a corresponding solution file");
      String LINES[] = loadStrings(solFile);
      boolean sFound = false;
      int sBegin = 0;
          
      for (int i = 0; i < LINES.length; i++) {
        String[] s = LINES[i].split("\\s+");
        
        if (sFound && (i>=sBegin) && (i<sBegin+nV)){
          values[i-sBegin] = float(s[0]);
        }
          
        if (LINES[i].contains("ertice") && sFound==false) {
          println("number of solutions is",LINES[i+1]);
          sBegin = i+3;
          sFound = true;
          values = new float[nV];
        }
      }
      
      //color[] palette = {color(0,0,255), color(255), color(255,0,0)};
      color[] palette = {color(0,0,255), color(100,100,255), color(0,255,0), color(255,255,0), color(255,0,0)};
      colors = new color[values.length];
      float mi = min(values);
      float ma = max(values);
      for (int i = 0; i < colors.length; i++) {
        float f = map(values[i], mi, ma, 0, palette.length-1.0001);
        colors[i] = lerpColor(palette[int(f)], palette[int(f+1)], f%1);
      }
    }
    else{
      println("No associated solution file");
    }
  }
  
  void createGeometry(){
    geometry = createShape();
    geometry.beginShape(TRIANGLES); 
    
    for(int i = 0 ; i < faces.length ; i++){
      geometry.fill(colors[faces[i][0]-1]);
      geometry.vertex(verts[faces[i][0]-1][0], verts[faces[i][0]-1][1], verts[faces[i][0]-1][2]);
      
      geometry.fill(colors[faces[i][1]-1]);
      geometry.vertex(verts[faces[i][1]-1][0], verts[faces[i][1]-1][1], verts[faces[i][1]-1][2]);
      
      geometry.fill(colors[faces[i][2]-1]);
      geometry.vertex(verts[faces[i][2]-1][0], verts[faces[i][2]-1][1], verts[faces[i][2]-1][2]);
    }
    geometry.endShape();
    geometry.setStroke(false);
    geometry.setStroke(color(255,75));
  }
  
  void scaleAndTranslate(){
    float scl=1000;
    float[] tr = new float[3];
    for(int i = 0 ; i < verts.length ; i++){
      for(int j = 0 ; j < 3 ; j++){
        bbBox[j][0] = min(bbBox[j][0], verts[i][j]);
        bbBox[j][1] = max(bbBox[j][1], verts[i][j]);
      }
    }
    for(int j = 0 ; j < 3 ; j++){
      tr[j] = -(bbBox[j][0] + bbBox[j][1])/2;
      scl = min(scl, 1.0f / (bbBox[j][1] - bbBox[j][0])) ;
    }
    geometry.scale(scl);
    geometry.translate(tr[0], tr[1], tr[2]);
  }
  
  void render() { 
    shape(geometry);
  } 
  
} 

File selectedFile;

protected String selectImage(final String prompt){
  try{
    SwingUtilities.invokeAndWait(new Runnable(){
      public void run(){
        JFileChooser fileDialog = new JFileChooser();
        fileDialog.setDialogTitle(prompt);
        FileNameExtensionFilter filter = new FileNameExtensionFilter(
            "Mesh file", "mesh"
        );
        fileDialog.setFileFilter(filter);
        int returnVal = fileDialog.showOpenDialog(null);
        if (returnVal == JFileChooser.APPROVE_OPTION){
          selectedFile = fileDialog.getSelectedFile();
        }
      }
    });
    return selectedFile == null ? null : selectedFile.getAbsolutePath();
  }
  catch (Exception e){
    e.printStackTrace();
    return null;
  }
}