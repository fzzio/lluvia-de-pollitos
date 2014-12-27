// Para hacer pruebas el menú es el siguiente
// 1. Intro (Splash)
// 2. Mecánica
// 3. Juego
// 4. Resumen
// 5. StandBy

// Librerias a usar
import java.io.*; // for the loadPathFilenames() function
import processing.opengl.*;
import processing.video.*; // para windows
import codeanticode.gsvideo.*; // para linux
import jp.nyatla.nyar4psg.*;
import javax.swing.*;
import java.util.*;


//////////////////////////////////////////////////////////////////////////////
//    VARIABLES GLOBALES
//////////////////////////////////////////////////////////////////////////////

//dimensiones de la pantalla
public int winWidth = 1366, winHeight = 768; //Cambia Dimensiones de la ventana

// dimensiones de la camara
public int capWidth = 640, capHeight = 480;

// dimensiones para visualización cámara
public int camViewWidth = 240, camViewHeight = 180;

//las dimensiones en las que el RA se llevarán a cabo.
public int arWidth = 640, arHeight = 480; //480 360


// Para ubicar la posicion de la camara
public String camPara = "camera_para.dat";

//public Capture videoC; // para windows
public GSCapture videoC; // para linux
public PImage video; // en esta variable mostramos el video invertido

public float ry;
public int numPixels;
public float displayScale;
public float mS = 0.2;
public float proporcionImagen = 0.80;

//Rutas
public String proyectPath = "";
//public String proyectPath = sketchPath("/home/fzzio/sketchbook/proyectos/lluviapollitos/");

// Imagenes, Videos y Fuentes
public int tamanoBebas = 160, tamanoTitan = 160;
public PFont fuenteBebas, fuenteTitan;
public Movie videoIntro;
public PImage[] imgObjetosError = new PImage[5];
public PImage[] imgNubes = new PImage[4];
public int posXNubes[] = {-200, 200, 900, 600};
public PImage imgBGSplash, imgBGMecanica, imgBGCampo, imgBGCielo, imgNidoA, imgNidoB, imgNidoVacio, imgContadorA, imgContadorB, imgGallina, imgPolloCayendo, imgPolloAtrapado, imgPolloEnNido, imgSeparador, imgError, imgFlechaIzq, imgFlechaDer;


// Objeto de NYARTOOL
public MultiMarker nya;
public int idMarker1, idMarker2;

// Estado del juego
public final int ESTADO_INTRO = 0, ESTADO_INSTRUCCIONES = 1, ESTADO_JUGANDO = 2, ESTADO_RESUMEN = 3, ESTADO_STAND_BY = 4;
public int estadoActualJuego = ESTADO_JUGANDO;

// Puntajes
public int puntosA = 0, puntosB = 0;

// Variables del juego
public Jugador jugadorA, jugadorB;
public ArrayList pollosA, pollosB, objetosError;
public Nido nidoA, nidoB;
public int posInicialXA = -1, posInicialXB = -1;
public Timer timerJuego, timerPantallas;


public int totalPollos = 50, totalObjerror = 50;
public int velocidad = 2;
public int atrapadosPollosA = 0, atrapadosPollosB = 0;
public boolean seDibujaCamara = false;

//////////////////////////////////////////////////////////////////////////////









//////////////////////////////////////////////////////////////////////////////
//    MÉTODOS GENERALES
//////////////////////////////////////////////////////////////////////////////


void setup(){
  // configuracion de la camara  
  size(winWidth, winHeight, P3D);
  //size(winWidth,winHeight,OPENGL);//tamaños de la pantalla
  frameRate(90);// para mejorar la velocidad de la imagen por cuadro  o 30


  //Cargamos Data para el juego
  cargarFuentes();
  cargarPatrones();
  cargarImagenes();
  cargarVideos();
  
  // Se setea el tiempo que dura el Juego
  timerJuego = new Timer(1000 * 60); // 60 segundos
  timerPantallas = new Timer(1000 * 5); // 60 segundos

  // Instaciamos objetos y variables para el juego
  nidoA = new Nido(imgNidoA, 0, (winWidth / 2), proporcionImagen );
  nidoB = new Nido(imgNidoB, (winWidth / 2) + 1, winWidth, proporcionImagen);

  jugadorA = new Jugador();
  jugadorB = new Jugador();

  pollosA = new ArrayList(totalPollos);
  pollosB = new ArrayList(totalPollos);
  for(int i=0; i< totalPollos; i++){
    pollosA.add(new Pollo(imgPolloCayendo, 0, 418, 590));
    pollosB.add(new Pollo(imgPolloCayendo, 515, 930, 590));
  }

  iniciarVideo();
}

void stop(){
  // Stop the GSVideo webcam capture
  videoC.stop();
  
  // detenemos el sketch
  this.stop();
}

void draw(){
  background(138, 218, 255);

  switch(estadoActualJuego) {
    case ESTADO_INTRO:
      verPantallaIntro();
      break;
    case ESTADO_INSTRUCCIONES:
      verPantallaInstrucciones();
      break;
    case ESTADO_JUGANDO: 
      verPantallaJuego();
      break;
    case ESTADO_RESUMEN:
      puntosA = 90; puntosB = 50;
      verPantallaResumen();
      break;
    case ESTADO_STAND_BY: 
      verPantallaStandBy();
      break;
  }  
}
void mousePressed(){

}

void keyReleased(){
  //

}

void keyPressed(){
  println("Presiono " + key);
  if(key == '1'){
    estadoActualJuego = ESTADO_INTRO;
    timerPantallas.start();
  }else if(key == '2'){
    estadoActualJuego = ESTADO_INSTRUCCIONES;
    timerPantallas.start();
  }else if(key == '3'){
    estadoActualJuego = ESTADO_JUGANDO;
    timerJuego.start();
  }else if(key == '4'){
    estadoActualJuego = ESTADO_RESUMEN;
  }else if(key == '5'){
    estadoActualJuego = ESTADO_STAND_BY;
  }else if(key == 'c' || key == 'C'){
    // Calibrando
    calibrar();
  }else if(key == 'm' || key == 'M'){
    if(seDibujaCamara == false){
      seDibujaCamara = true;
    }else{
      seDibujaCamara = false;
    }
  }else{
    // Hacer algo o nada
  }
}

//////////////////////////////////////////////////////////////////////////////









//////////////////////////////////////////////////////////////////////////////
//    METODOS DE PANTALLAS
//////////////////////////////////////////////////////////////////////////////

// Pantalla con video de introducción
public void verPantallaIntro(){
  //println("Mostrando Intro");
  videoIntro.stop();

  pushMatrix();
    loadPixels();
      image(imgBGSplash, 0, 0, winWidth, winHeight);
    updatePixels();
  popMatrix();

  if(timerPantallas.isFinished()){
    estadoActualJuego = ESTADO_INSTRUCCIONES;
    timerPantallas.start();
  }
}

// Pantalla con juego
public void verPantallaInstrucciones(){
  //println("Mostrando Instrucciones del juego");
  
  videoIntro.stop();
  pushMatrix();
    loadPixels();
      image(imgBGMecanica, 0, 0, winWidth, winHeight);
    updatePixels();
  popMatrix();

  float anchoPolloNuevo = imgPolloEnNido.width * 0.80;
  float altoPolloNuevo = imgPolloEnNido.height * 0.80;

  pushMatrix();
    loadPixels();
      image(imgPolloEnNido, ((winWidth - anchoPolloNuevo ) / 2), (((winHeight - altoPolloNuevo ) / 2) - 150 ), anchoPolloNuevo, altoPolloNuevo);
    updatePixels();
  popMatrix();
  
  pushMatrix();
    loadPixels();
      textFont(fuenteTitan, 100);
      textAlign(CENTER);
      fill(0, 157, 224);
      translate(((winWidth - anchoPolloNuevo ) / 2) + 100, ((winHeight - altoPolloNuevo ) / 2) + 230, 0);
      text("Mecánica", 0, 0);
      noFill();
    updatePixels();
  popMatrix();
  
  pushMatrix();
    loadPixels();
      textFont(fuenteBebas, 50);
      textAlign(CENTER);
      fill(21, 40, 132);
      translate(((winWidth - anchoPolloNuevo ) / 2) + 100, ((winHeight - altoPolloNuevo ) / 2) + 320, 0);
      text("Con el nido atrapa la mayor cantidad de\n pollitos que caen del cielo", 0, 0);
      noFill();
    updatePixels();
  popMatrix();


  
  // Verificamos si el video está disponible
  if (videoC.available()) {
    videoC.read();
    
    //loadPixels();
    //videoC.loadPixels();
    //video = mirrorImage(videoC);
    //videoC.updatePixels();
    //updatePixels();

    // Detecta si hay marcadores de Realidad Aumentada
    PImage cSmall = videoC.get();
    cSmall.resize(arWidth, arHeight);
    nya.detect(cSmall); // detect markers in the image

    calibrar();
    
    pushMatrix();
      loadPixels();
        textFont(fuenteBebas, 25);
        textAlign(LEFT);
        fill(21, 40, 132);
        if(posInicialXA != -1){
          text("Jugador 1 Calibrado", 100, winHeight - 100);
        }
        
        if(posInicialXB != -1){
          text("Jugador 2 Calibrado", 100, winHeight - 75);
        }
        
        if(posInicialXA != -1 && posInicialXB != -1){
          text("Está calibrado. Presione '3' para continuar.", 100, winHeight - 50);
        }else{
          text("Calibrando...", 100, winHeight - 50);
        }
        noFill();
      updatePixels();
    popMatrix();
    
    
    

    dibujarCamara();
    
  }else{
    println("Se perdió conexión a la cámara.");
  }
  
  
 
  
  
  /*if(timerPantallas.isFinished()){
    estadoActualJuego = ESTADO_JUGANDO;
    timerJuego.start();
  }*/
}


// Pantalla con juego
public void verPantallaJuego(){
  //println("Mostrando Juego");

  videoIntro.stop();
  
  // Dibujamos la interfaz
  dibujarInterfazJuego();

  // Verificamos si el video está disponible
  if (videoC.available()) {
    videoC.read();
    
    //loadPixels();
    //videoC.loadPixels();
    //video = mirrorImage(videoC);
    //videoC.updatePixels();
    //updatePixels();

    // Detecta si hay marcadores de Realidad Aumentada
    PImage cSmall = videoC.get();
    cSmall.resize(arWidth, arHeight);
    nya.detect(cSmall); // detect markers in the image

    dibujarElementos();

    dibujarCamara();
    
  }else{
    println("Se perdió conexión a la cámara.");
  }









  if(timerJuego.isFinished()){
    estadoActualJuego = ESTADO_RESUMEN;
    timerPantallas.start();
  }


}

// Pantalla con resumen con puntajes
public void verPantallaResumen(){
  //println("Mostrando Resumen");

  videoIntro.stop();

  float anchoGallinaNuevo = imgGallina.width * 0.80;
  float altoGallinaNuevo = imgGallina.height * 0.80;

  background(255, 255, 255);

  pushMatrix();
    loadPixels();
      image(imgGallina, ((winWidth - anchoGallinaNuevo ) / 2), (((winHeight - altoGallinaNuevo ) / 2) - 150 ), anchoGallinaNuevo, altoGallinaNuevo);
    updatePixels();
  popMatrix();
  
  pushMatrix();
    loadPixels();
      textFont(fuenteTitan, 80);
      textAlign(CENTER);
      fill(0, 157, 224);
      translate(((winWidth - anchoGallinaNuevo ) / 2) + 100, ((winHeight - altoGallinaNuevo ) / 2) + 230, 0);
      text("Fin del Juego", 0, 0);
      noFill();
    updatePixels();
  popMatrix();
  
  float anchoContadorA = imgContadorA.width * 0.80;
  float altoContadorA = imgContadorA.height * 0.80;
  int posXA = (int) ((winWidth - anchoContadorA ) / 4);
  int posYA = (int) (((winHeight - altoContadorA ) / 2) + 250 );

  float anchoContadorB = imgContadorB.width * 0.80;
  float altoContadorB  = imgContadorB.height * 0.80;
  int posXB = (int) ((winWidth - anchoContadorB ) / 4) * 3;
  int posYB = (int) (((winHeight - altoContadorB ) / 2) + 250 );
  
  pushMatrix();
    loadPixels();
      textFont(fuenteBebas, 60);
      textAlign(CENTER);
      fill(250, 250, 250);
        // puntaje A
        image(imgContadorA, posXA, posYA, anchoContadorA, altoContadorA);
        text(puntosA, posXA + 40, posYA + 60);

        image(imgContadorB, posXB , posYB, anchoContadorB, altoContadorB );
        text(puntosB, posXB + 40, posYB + 60);
      noFill();
    updatePixels();
  popMatrix();

  pushMatrix();
    loadPixels();
      float anchoFlecha = imgFlechaIzq.width * 0.80;
      float altoFlecha  = imgFlechaIzq.height * 0.80;

      if (puntosA > puntosB) {
        image(imgFlechaIzq, ((winWidth - anchoFlecha ) / 2), posYA + 40, anchoFlecha, altoFlecha);
      }else if (puntosA < puntosB) {
        image(imgFlechaDer, ((winWidth - anchoFlecha ) / 2), posYA + 40, anchoFlecha, altoFlecha);
      }else{
        // TODO
      }
    updatePixels();
  popMatrix();

  if(timerJuego.isFinished()){
    estadoActualJuego = ESTADO_STAND_BY;
  }
}

// Pantalla con resumen con video StandBy
public void verPantallaStandBy(){
  //println("Mostrando StandBy");
  pushMatrix();
    loadPixels();
      videoIntro.play();

      if (videoIntro.available()) {
        videoIntro.read();
      }
      image(videoIntro, 0, 0, winWidth, winHeight);
    updatePixels();
  popMatrix();
}

//////////////////////////////////////////////////////////////////////////////









//////////////////////////////////////////////////////////////////////////////
//    METODOS DE CARGA DE DATOS
//////////////////////////////////////////////////////////////////////////////

public void cargarPatrones(){
  // Marcador de Nyartoolkit
  nya = new MultiMarker(this, arWidth, arHeight, camPara, NyAR4PsgConfig.CONFIG_PSG);
  
  // set the delay after which a lost marker is no longer displayed. by default set to something higher, but here manually set to immediate.
  nya.setLostDelay(1);

  idMarker1 = nya.addARMarker("patt/patt.hiro", 80);
  idMarker2 = nya.addARMarker("patt/patt.kanji", 80);
}


public void cargarImagenes(){
  // Cargamos las imágenes de las nubes
  imgNubes[0] = loadImage("img/nube1.png");
  imgNubes[1] = loadImage("img/nube2.png");
  imgNubes[2] = loadImage("img/nube3.png");
  imgNubes[3] = loadImage("img/nube4.png");

  // Cargamos las imágenes de los objetos erroneos  
  imgObjetosError[0] = loadImage("img/llanta.png");
  imgObjetosError[1] = loadImage("img/tabla1.png");
  imgObjetosError[2] = loadImage("img/tabla2.png");
  imgObjetosError[3] = loadImage("img/tubo1.png");
  imgObjetosError[4] = loadImage("img/tubo2.png");

  // Cargamos imágenes del juego
  imgBGSplash = loadImage("img/splash.jpg");
  imgBGMecanica = loadImage("img/bgmecanica.jpg");
  imgBGCampo = loadImage("img/campo.png");
  imgBGCielo = loadImage("img/cielo.jpg");
  
  imgNidoA = loadImage("img/handblue.png");
  imgNidoB = loadImage("img/handred.png");
  imgNidoVacio = loadImage("img/handsinsenal.png");

  imgContadorA = loadImage("img/contadorblue.png");
  imgContadorB = loadImage("img/contadorred.png");
  
  imgGallina = loadImage("img/gallina.png");
  imgPolloCayendo = loadImage("img/pollito-cayendo.png");
  imgPolloAtrapado = loadImage("img/pollito-atrapado.png");
  imgPolloEnNido = loadImage("img/pollito-en-el-nido.png");
  
  imgSeparador = loadImage("img/separador.png");
  imgError = loadImage("img/x.png");

  imgFlechaIzq = loadImage("img/arrowleft.png");
  imgFlechaDer = loadImage("img/arrowright.png");
}

public void cargarVideos(){
  videoIntro = new Movie(this, "video/intro.mov");
  videoIntro.loop();
  videoIntro.pause();
  //videoIntro.volume(0);
  
}

public void cargarFuentes(){
  fuenteBebas = createFont("fonts/BebasNeue.otf", tamanoBebas, true);
  fuenteTitan = createFont("fonts/TitanOne-Regular.ttf", tamanoTitan, true);
  //stroke(0);
  //strokeWeight(5);
}
//////////////////////////////////////////////////////////////////////////////









//////////////////////////////////////////////////////////////////////////////
//    METODOS ADICIONALES PARA FUNCIONALIDAD
//////////////////////////////////////////////////////////////////////////////

// Llamado cada vez que un nuevo frame está disponible para leer
void movieEvent(Movie m) {
  m.read();
}


PImage mirrorImage(PImage source){
  // Create new storage for the result RGB image 
  
  PImage response = createImage(source.width, source.height, RGB);
  
  // Load the pixels data from the source and destination images
  
  source.loadPixels();
  response.loadPixels();
    
  // Walk thru each pixel of the source image
  
  for (int x=0; x<source.width; x++){
    for (int y=0; y<source.height; y++){
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
  
  source.updatePixels();
  response.updatePixels();  
  
  // Return the result image with the pixels inverted
  // over the x axis 
  
  return response;
}

//////////////////////////////////////////////////////////////////////////////









//////////////////////////////////////////////////////////////////////////////
//    METODOS ADICIONALES PARA GRAFICA
//////////////////////////////////////////////////////////////////////////////

// Llamado cada vez que un nuevo frame está disponible para leer
void dibujarInterfazJuego() {
  //Para el cielo
  pushMatrix();
    loadPixels();
      float altoCieloNuevo = imgBGCielo.height * 0.60;
      image(imgBGCielo, 0, 0, winWidth, altoCieloNuevo);
    updatePixels();
  popMatrix();

  //para las nubes
  pushMatrix();
    loadPixels();
      float porcentajeNuevo = 0.70;
      image(imgNubes[0], posXNubes[0], 20, imgNubes[0].width * porcentajeNuevo, imgNubes[0].height * porcentajeNuevo);
      image(imgNubes[1], posXNubes[1], 60, imgNubes[1].width * porcentajeNuevo, imgNubes[1].height * porcentajeNuevo);
      image(imgNubes[2], posXNubes[2], 45, imgNubes[2].width * porcentajeNuevo, imgNubes[2].height * porcentajeNuevo);
      image(imgNubes[3], posXNubes[3], 50, imgNubes[3].width * porcentajeNuevo, imgNubes[3].height * porcentajeNuevo);

      for (int i = 0; i < imgNubes.length; ++i) {
        if (posXNubes[i] >= winWidth) {
           posXNubes[i] = (int) ( imgNubes[i].width * porcentajeNuevo ) * (-1) ;
        }else{
           posXNubes[i] = posXNubes[i] + 2;
        }
      }
    updatePixels();
  popMatrix();


  // Para el campo
  pushMatrix();
    loadPixels();
      float altoCampoNuevo = imgBGCampo.height * 0.70;
      image(imgBGCampo, 0, abs(winHeight - altoCampoNuevo) + 50, winWidth, altoCampoNuevo);
    updatePixels();
  popMatrix();

  // Dividir Pantalla y mostrar el timerJuego
  pushMatrix();
    loadPixels();
      float altoSeparadorNuevo = imgSeparador.height * 0.70;
      float anchoSeparadorNuevo = imgSeparador.width * 0.70;
      image(imgSeparador, ((winWidth - anchoSeparadorNuevo ) / 2), abs(winHeight - altoCampoNuevo), anchoSeparadorNuevo, altoCampoNuevo);
      
      fill(0, 0, 0);
        text(" " + timerJuego.getSegundosRestantes(), ((winWidth - anchoSeparadorNuevo ) / 2 + 40), 100 );
      noFill();
    updatePixels();
  popMatrix();


  // Dibujar contadores de puntajes
  pushMatrix();
    float anchoContadorA = imgContadorA.width * 0.80;
    float altoContadorA = imgContadorA.height * 0.80;
    int posXA = (int) ( 100 );
    int posYA = (int) ( 50 );
    
    float anchoContadorB = imgContadorB.width * 0.80;
    float altoContadorB  = imgContadorB.height * 0.80;
    int posXB = (int) ( winWidth - anchoContadorB - 100 );
    int posYB = (int) ( 50 );
  
    loadPixels();
      textFont(fuenteBebas, 60);
      textAlign(CENTER);
      fill(250, 250, 250);
      
      // puntaje A
      image(imgContadorA, posXA, posYA, anchoContadorA, altoContadorA);
      text(puntosA, posXA + 40, posYA + 60);

      image(imgContadorB, posXB , posYB, anchoContadorB, altoContadorB );
      text(puntosB, posXB + 40, posYB + 60);
      
      noFill();
    updatePixels();
  popMatrix();
}

public void iniciarVideo(){
  // to correct for the scale difference between the AR detection coordinates and the size at which the result is displayed
  displayScale = (float) winWidth / arWidth;
  
  
  //videoC = new Capture(this,capWidth,capHeight,15); // para windows
  videoC = new GSCapture(this, capWidth, capHeight, "/dev/video0"); // para linux
  videoC.start();
  
  // Mostramos en consola las resoluciones soportadas por la webcam
  println("\nResoluciones soportadas por la webcam");
  int[][] res = videoC.resolutions();
  for (int i = 0; i < res.length; i++) {
    println(res[i][0] + "x" + res[i][1]);
  }
  
  // Mostramos en consola los framerates soportados por la webcam
  println("\nFramerates soportados por la webcam");
  String[] fps = videoC.framerates();
  for (int i = 0; i < fps.length; i++) {
    println(fps[i]);
  }
  
  video = createImage(videoC.width, videoC.height, RGB);
  numPixels = videoC.width * videoC.height;
}

public void dibujarCamara(){
  if(seDibujaCamara){
    pushMatrix();
      hint(DISABLE_DEPTH_TEST); // variables de Nayrtoolkit
        image(videoC, (winWidth - camViewWidth) / 2 , 125, camViewWidth, camViewHeight );
        rect( (winWidth - camViewWidth) / 2 , 125, camViewWidth, camViewHeight );
      hint(ENABLE_DEPTH_TEST);
    popMatrix();
  }
}


public void dibujarElementos(){
  float proporcionNidos = 0.80;
  
  //println("DATOS NIDO A: " + nidoA.toString() );
  //println("DATOS NIDO B: " + nidoB.toString() );
  

  // Para el marcador 1
  if(nya.isExistMarker( idMarker1 )){
    println("Hiro");
    //scale(displayScale);
    //nya.setARPerspective();

    moverNidoJuego(nidoA, posInicialXA, Math.round(nya.getMarkerVertex2D(idMarker1)[0].x), proporcionNidos );

    

  }else{
    pushMatrix();
      loadPixels();
        image(imgNidoVacio, nidoA.getPosX(), nidoA.getPosY(), imgNidoVacio.width * proporcionNidos, imgNidoVacio.height * proporcionNidos);
      updatePixels();
    popMatrix();
  }
  
  // Para el marcador 2
  if(nya.isExistMarker( idMarker2 )){
    println("Kanji");

    PVector vector2 = nya.getMarkerVertex2D(idMarker2)[0];
    nidoB.dibujarNido(Math.round(vector2.x), proporcionNidos);
    println(Math.round(vector2.x));
    //nidoB.dibujarNido(proporcionNidos); 
  }else{
    pushMatrix();
      loadPixels();
        image(imgNidoVacio, nidoB.getPosX(), nidoB.getPosY(), imgNidoVacio.width * proporcionNidos, imgNidoVacio.height * proporcionNidos);
      updatePixels();
    popMatrix();
  }

  perspective();
}


public void calibrar(){
  // Para el marcador 1
  if(nya.isExistMarker( idMarker1 )){
    posInicialXA = Math.round( nya.getMarkerVertex2D(idMarker1)[0].x );
    nidoA.setPosX( (nidoA.getLimiteMaxX() - nidoA.getLimiteMinX())/2 );
    //println("Calibrando... Pos X Nido A: " + posInicialXA);
  }

  // Para el marcador 2
  if(nya.isExistMarker( idMarker2 )){
    posInicialXB = Math.round( nya.getMarkerVertex2D(idMarker2)[0].x ); 
    nidoB.setPosX( (nidoB.getLimiteMaxX() - nidoB.getLimiteMinX())/2 );
    //println("Calibrando... Pos X Nido B: " + posInicialXB);
  }
}

public void moverNidoJuego(Nido nido, int posCalibradaX, int posActualX, float proporcion){
  //int minX = nido.getLimiteMinX(), maxX = getLimiteMaxX(), posX = nido.getPosX();

  int movimiento = posActualX - posCalibradaX;
  nido.setPosX( nido.getPosX() + movimiento );

  nido.dibujarNido(proporcion);

}
//////////////////////////////////////////////////////////////////////////////
