  // Para calibrar color se tiene que:
  // 1. Tener presionada tecla 1 y dar click con el mouse sobre la region del color que se quiere calibrar para el jugador A
  // 2. Tener presionada tecla 2 y dar click con el mouse sobre la region del color que se quiere calibrar para el jugador B
  // Una vez calibrados los 2 colores se procede a presionar el 3 y dar click en cualquier area de la camara para pasar a la pantalla del juego
  
// Librerias a usar
import processing.opengl.*;
//import processing.video.*; // para windows
import codeanticode.gsvideo.*; // para linux
import jp.nyatla.nyar4psg.*;

// Imagenes a usar
PImage imgFondo;

Jugador jugadorA, jugadorB;
ArrayList pollosA, pollosB;
int totalPollos = 30;
int velocidad = 2;
int atrapadosPollosA = 0, atrapadosPollosB = 0;
Nido    nidoA, nidoB;

Timer   timer;
PFont   fuente;
boolean finDelJuego = false;

// Calibraciones y colores de juego
boolean estaCalibrado = false;
color trackColorA, trackColorB;
float aTrackR, aTrackG, aTrackB;
float bTrackR, bTrackG, bTrackB;

String mensaje = "";

//Capture videoC; // para windows
GSCapture videoC; // para linux
PImage video; // en esta variable mostramos el video invertido

int posXInicialA, posXInicialB;

/********CHROMA KEY********/
int numPixels;
int keyColor = 0xff000000;
int keyR = (keyColor >> 16) & 0xFF;
int keyG = (keyColor >> 8) & 0xFF;
int keyB = keyColor & 0xFF;
int thresh = 60; // tolerance of

/********NYARTOOL ********/
MultiMarker nya;
int idMarker,idMarker2;

void setup()
{
  size(1280, 720, P3D);
  frameRate(30);  
  
  //video = new Capture(this,width,height,15); // para windows
  videoC = new GSCapture(this, 1280, 720); // para linux
  numPixels = videoC.width * videoC.height;
  
  /********NYARTOOL********/
  nya=new MultiMarker(this,width,height,"camera_para.dat",NyAR4PsgConfig.CONFIG_PSG);
  idMarker=nya.addARMarker("patt.hiro",80);
  idMarker2=nya.addARMarker(loadImage("img/mipatt.png"),16,25,80);
  
  videoC.start();
  video = createImage(videoC.width, videoC.height, RGB);
  
  imgFondo = loadImage("img/fondo.png");
  jugadorA = new Jugador();
  jugadorB = new Jugador();
  pollosA = new ArrayList(totalPollos);
  pollosB = new ArrayList(totalPollos);
    for(int i=0; i< totalPollos; i++){
      pollosA.add(new Pollo(loadImage("img/polloA.png"), 0, 418, 590));
      pollosB.add(new Pollo(loadImage("img/polloB.png"), 515, 930, 590));
    }
  nidoA = new Nido(loadImage("img/nidoA.png"), 0, 300);
  nidoB = new Nido(loadImage("img/nidoB.png"), 515, 810);
  
  timer = new Timer(1000 * 60); // 60 segundos
  
  fuente = createFont("Arial",12,true);

  
}

void stop()
{
  // Stop the GSVideo webcam capture
  videoC.stop();
  // Stop the sketch
  this.stop();
}

void draw()
{
  //background(video);
  // Caragamos datos de la camara
  if (videoC.available()) {
    videoC.read();
    video = mirrorImage(videoC);
    
    /********CHROMA KEY********/
    //background(0xffff0000);
    background(imgFondo);
    loadPixels();    
    videoC.loadPixels(); // Make the pixels of video available    

    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      // Fetch the current color in that location
      color currColor = videoC.pixels[i];
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;

      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - keyR);
      int diffG = abs(currG - keyG);
      int diffB = abs(currB - keyB);

      // Render the pixels wich are not the close to the keyColor to the screen

      if((diffR + diffG + diffB)> thresh){
        pixels[i] = videoC.pixels[i];      
      } 
    }
    updatePixels(); // Notify that the pixels[] array has changed
  }
  
  /********NYARTOOL********/
  nya.detect(videoC);
  //nya.drawBackground(videoC);
  if((nya.isExistMarker(0))){
    nya.beginTransform(0);
    fill(0,0,255);
    translate(0,0,20);
    box(40);
    nya.endTransform();  
    PVector vector=nya.getMarkerVertex2D(idMarker)[0];
    PVector vector2=nya.getMarkerVertex2D(idMarker2)[0];
    nidoA.dibujarNido(Math.round(vector.x),Math.round(vector.y));
    nidoB.dibujarNido(Math.round(vector2.x),Math.round(vector2.y));
    //nidoB.dibujarNido();
  }    
  
  if (!estaCalibrado){
    // Si no esta calibrado (detectado los colores), mostramos la ventana donde se debe seleccionar el color
    pushMatrix();
      image(video, 0, 0);
      //image(video, (width - video.width)/2, (height - video.height)/2);
    popMatrix();
    dibujarColoresDetectados();
    pushMatrix();
      textFont(fuente,30);
      textAlign(CENTER);
      text(mensaje, width/2, 620);
    popMatrix();
  }else{
    if (finDelJuego) {
      mostrarResumenJuego();
    } 
    else{
      mostrarTiempo(500, 40);
      
      mostrarPuntos(jugadorA, 10, 60);
      mostrarPuntos(jugadorB, 860, 60);    
      
      // Jugador A
      int k = pollosA.size() - 1; // siempre visualizamos el ultimo pollo
      if (pollosA.size() > 0){
        //println("# Pollos: " + pollosA.size() + " Velocidad: " + jugadorA.getVelocidad());
        ((Pollo)pollosA.get(k)).setVelocidad(jugadorA.getVelocidad());
        ((Pollo)pollosA.get(k)).caer();
        ((Pollo)pollosA.get(k)).dibujarPollo();  
        
        // si llego al piso o si fue atrapado
        if(((Pollo)pollosA.get(k)).llegoAlPiso()){
          // si es atrapado se deben de sumar los puntos al jugador, caso contrario le resta puntos
          if (polloAtrapado((Pollo)pollosA.get(k), nidoA)){
           jugadorA.aumentarPuntos(); 
          }else{
            jugadorA.reducirPuntos();
          }

          // se elimina el elemento pollo y se aumenta la velocidad
          pollosA.remove(k);
          jugadorA.aumentarVelocidad();
        }
      }else{
        finDelJuego = true;
      }
            
      // Jugador B
      int l = 0; // siempre visualizamos el ultimo pollo
      if (pollosB.size() > 0){
        //println("# Pollos: " + pollosB.size() + " Velocidad: " + jugadorB.getVelocidad());
        ((Pollo)pollosB.get(l)).setVelocidad(jugadorB.getVelocidad());
        ((Pollo)pollosB.get(l)).caer();
        ((Pollo)pollosB.get(l)).dibujarPollo();  
        
        // si llego al piso o si fue atrapado
        if(((Pollo)pollosB.get(l)).llegoAlPiso()){
          // si es atrapado se deben de sumar los puntos al jugador, caso contrario le resta puntos
          if (polloAtrapado((Pollo)pollosB.get(l), nidoB)){
           jugadorB.aumentarPuntos(); 
          }else{
            jugadorB.reducirPuntos();
          }
          
          // se elimina el elemento pollo y se aumenta la velocidad
          pollosB.remove(l);
          jugadorB.aumentarVelocidad();
        }
      }else{
        finDelJuego = true;
      }
      
      //asignarPosicionesDetectadas();
      //Dibujamos Nidos segun posiciones detectadas
      //nidoA.dibujarNido();
      //nidoB.dibujarNido();
      
      if(timer.isFinished()){
        finDelJuego = true;
      }
    }  
  
  }
  
}
void mousePressed(){
  if(!estaCalibrado && mouseX < video.width && mouseY < video.height){
    keyPressed();
    if(key == '1'){
      int loc = mouseX + mouseY*video.width;
      trackColorA = video.pixels[loc];
      aTrackR = red(trackColorA);
      aTrackG = green(trackColorA);
      aTrackB = blue(trackColorA);
      mensaje = "Calibrando color para Jugador A: [" + aTrackR + ", " + aTrackG + ", " + aTrackB + "].";
    }else if(key == '2'){
      int loc = mouseX + mouseY*video.width;
      trackColorB = video.pixels[loc];
      bTrackR = red(trackColorB);
      bTrackG = green(trackColorB);
      bTrackB = blue(trackColorB);
      mensaje = "Calibrando color para Jugador B: [" + bTrackR + ", " + bTrackG + ", " + bTrackB + "].";
    }else if(key == '3'){
      estaCalibrado = true;
      timer.start();
    }
  }
  else{
    
    keyColor = get(mouseX, mouseY);
    keyR = (keyColor >> 16) & 0xFF;
    keyG = (keyColor >> 8) & 0xFF;
    keyB = keyColor & 0xFF;
    
  }
}

void keyReleased(){
  mensaje = "";
}


//Mueve el nido A y B acorde al tracking de los colores
public void asignarPosicionesDetectadas(){
  float worldRecord1 = 500, worldRecord2 = 500;
  int closestX1 = 0, closestX2 = 0;
  int closestY1 = 0, closestY2 = 0;
  
  for(int x = 0; x < video.width; x ++ ) {
    for(int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;

      // Obtenemos los datos para el color actual
      color colorActual = video.pixels[loc];
      float actR = red(colorActual);
      float actG = green(colorActual);
      float actB = blue(colorActual);
      
      //Comparamos con los colores detectados en A con distancia Euclidiana
      float dA = dist(actR, actG, actB, aTrackR, aTrackG, aTrackB);
      float dB = dist(actR, actG, actB, bTrackR, bTrackG, bTrackB);      
      
      if (dA < worldRecord1) {
        worldRecord1 = dA;
        closestX1 = x;
        closestY1 = y;
      }
      if (dB < worldRecord2) {
        worldRecord2 = dB;
        closestX2 = x;
        closestY2 = y;
      }
    }
  }
  //Mueve nidoA
  if (worldRecord1>0) {

        int posActualNA = nidoA.getPosX();
        int posXNuevaNA = closestX1;
        
        if(posXNuevaNA < posXInicialA){
          // moverlo izq 
          posActualNA -=10;
              if(posActualNA < nidoA.getLimiteMinX()){
              posActualNA = nidoA.getLimiteMinX();
          }
          nidoA.setPosX(posActualNA);
          
        }else if(posXNuevaNA > posXInicialA){
         // moverlo derecha
           posActualNA +=10;
           if(posActualNA > nidoA.getLimiteMaxX()){
             posActualNA = nidoA.getLimiteMaxX();
           }
          nidoA.setPosX(posActualNA);
        }
        
        nidoA.dibujarNido();
        
        
        
        
  }
 //Mueve nidoB 
          if (worldRecord2>0) {
      
          int posActualNB = nidoB.getPosX();
          int posXNuevaNB = closestX2;
          
          if(posXNuevaNB < posXInicialB){
            // moverlo izq 
            posActualNB -=5;
           
            if(posActualNB < nidoB.getLimiteMinX()){
              posActualNB = nidoB.getLimiteMinX();
            }
            nidoB.setPosX(posActualNB);
          }else if(posXNuevaNB > posXInicialB){
           // moverlo derecha
             posActualNB +=5;
             if(posActualNB > nidoB.getLimiteMaxX()){
               posActualNB = nidoB.getLimiteMaxX();
             }
            nidoB.setPosX(posActualNB);
          }
          nidoB.dibujarNido();
      }
}

//primera version del movimiento de nidos
/*void asignarPosicionesDetectadas(){
  float worldRecord1 = 500, worldRecord2 = 500;
  int closestX1 = 0, closestX2 = 0;
  int closestY1 = 0, closestY2 = 0;
  
  for(int x = 0; x < video.width; x ++ ) {
    for(int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;

      // Obtenemos los datos para el color actual
      color colorActual = video.pixels[loc];
      float actR = red(colorActual);
      float actG = green(colorActual);
      float actB = blue(colorActual);
      
      //Comparamos con los colores detectados en A con distancia Euclidiana
      float dA = dist(actR, actG, actB, aTrackR, aTrackG, aTrackB);
      float dB = dist(actR, actG, actB, bTrackR, bTrackG, bTrackB);      
      
      if (dA < worldRecord1) {
        worldRecord1 = dA;
        closestX1 = x;
        closestY1 = y;
      }
      if (dB < worldRecord2) {
        worldRecord2 = dB;
        closestX2 = x;
        closestY2 = y;
      }
    }
  }
  
  if (worldRecord1>0) {
    int posActualNA = nidoA.getPosX();
    if((posActualNA - closestX1) < 0){
      // mover a la derecha
      if(posActualNA < nidoA.getLimiteMaxX()){
        posActualNA +=5;
      }else{
        posActualNA = nidoA.getLimiteMaxX();
      }
    }else if((posActualNA - closestX1) > 0){
      // mover a la izquierda      
      if(posActualNA > nidoA.getLimiteMinX()){
        posActualNA -=5;
      }else{
        posActualNA = nidoA.getLimiteMinX();
      }
    }
    nidoA.setPosX(posActualNA);
    nidoA.dibujarNido();

  }
  
  if (worldRecord2 > 0) {
    int posActualNB = nidoB.getPosX();
    
    
    if((posActualNB - closestX2) < 0){
      // mover a la derecha
      
      if(posActualNB < nidoB.getLimiteMaxX()){
        posActualNB += 5;
      }else{
        posActualNB = nidoB.getLimiteMaxX();
      }
    }else if((posActualNB - closestX2) > 0){
      // mover a la izquierda
            
      if(posActualNB > nidoB.getLimiteMinX()){
        posActualNB -=5;
      }else{
        posActualNB = nidoB.getLimiteMinX();
      }
    }
    nidoB.setPosX(posActualNB);
    
    
  }
}*/


public void dibujarColoresDetectados(){
  float worldRecord1 = 500, worldRecord2 = 500;
  int closestX1 = 0, closestX2 = 0;
  int closestY1 = 0, closestY2 = 0;
  
  for(int x = 0; x < video.width; x ++ ) {
    for(int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;

      // Obtenemos los datos para el color actual
      color colorActual = video.pixels[loc];
      float actR = red(colorActual);
      float actG = green(colorActual);
      float actB = blue(colorActual);
      
      //Comparamos con los colores detectados en A con distancia Euclidiana
      float dA = dist(actR, actG, actB, aTrackR, aTrackG, aTrackB);
      float dB = dist(actR, actG, actB, bTrackR, bTrackG, bTrackB);      
      
      if (dA < worldRecord1) {
        worldRecord1 = dA;
        closestX1 = x;
        closestY1 = y;
      }
      if (dB < worldRecord2) {
        worldRecord2 = dB;
        closestX2 = x;
        closestY2 = y;
      }
    }
  }
  
  if (worldRecord1 < 10) { 
    // Draw a circle at the tracked pixel
    fill(trackColorA);
    strokeWeight(4.0);
    stroke(0);
    ellipse(closestX1,closestY1,20,20);
    posXInicialA = closestX1;
  }
  
  if (worldRecord2 < 10) { 
    // Draw a circle at the tracked pixel
    fill(trackColorB);
    strokeWeight(4.0);
    stroke(0);
    ellipse(closestX2,closestY2,20,20);
    posXInicialB = closestX2;
  }
}

public boolean polloAtrapado(Pollo pollo, Nido nido){
  int polloPosMinX, polloPosMaxX;
  int nidoPosMinX, nidoPosMaxX;
  
  polloPosMinX = pollo.getPosX();
  polloPosMaxX = pollo.getPosX() + pollo.getImgPollo().width;

  nidoPosMinX = nido.getPosX();
  nidoPosMaxX = nido.getPosX() + nido.getImgNido().width;
  
  // se marca como atrapados los pollos que caen dentro del nido,
  // el valor de 32 que se suma a nido es para que no cuente como valido cuando caen en las flechas
  // el valor de 30 que se suma al minimo de pollo es para que no cuente si solo es el rabo
  if((polloPosMaxX >= (nidoPosMinX + 32)) && ((polloPosMinX + 30) <= (nidoPosMaxX - 32))){
    //println("pollo Atrapado");
    return true;
  }else{
    //println("pollo Caido");
    return false;
  }
}

public void mostrarPuntos(Jugador jugador, int posX, int posY){
  pushMatrix();
    textFont(fuente,30);
    textAlign(LEFT);
    text("Puntos: " + jugador.getPuntos() + ".", posX, posY);
  popMatrix();
}

void mostrarTiempo(int posX, int posY){
  pushMatrix();
    textFont(fuente,30);
    textAlign(CENTER);
    text("Tiempo: " + timer.getSegundosRestantes() + ".", posX, posY);
  popMatrix();
}

public void mostrarResumenJuego(){
  // Mostramos el resumen del juego, quien gano, perdio o empato y cuantos puntos se hizo
  textFont(fuente,48);
  textAlign(CENTER);
  fill(0);
  text("FIN DEL JUEGO",width/2,height/2);
  fill(255);
  textFont(fuente,50);
  if (jugadorA.getPuntos() > jugadorB.getPuntos()){
    text("Ganador Jugador A !" , width/2, height/2 + 60);
  }else if (jugadorA.getPuntos() < jugadorB.getPuntos()){
    text("Ganador Jugador B !" , width/2, height/2 + 60);
  }else{
    text("Empate !" , width/2, height/2 + 60);
  }
  
  textFont(fuente,20);
  fill(0);
  text("Jugador A: " + jugadorA.getPuntos() + " puntos.", width/2, height/2 + 100);
  text("Jugador B: " + jugadorB.getPuntos() + " puntos.", width/2, height/2 + 130);
}



PImage mirrorImage(PImage source){
  // Create new storage for the result RGB image 
  
  PImage response = createImage(source.width, source.height, RGB);
  
  // Load the pixels data from the source and destination images
  
  source.loadPixels();
  
  response.loadPixels();  
    
  // Walk thru each pixel of the source image
  
  for (int x=0; x<source.width; x++) 
  {
    for (int y=0; y<source.height; y++) 
    {
      // Calculate the inverted X (loc) for the current X
      
      int loc = (source.width - x - 1) + y * source.width;

      // Get the color (brightness for B/W images) for 
      // the inverted-X pixel
      
      color c = source.pixels[loc];
      
      // Store the inverted-X pixel color information 
      // on the destination image
      
      response.pixels[x + y * source.width] = c;
    }
  }
  
  // Return the result image with the pixels inverted
  // over the x axis 
  
  return response;
}
