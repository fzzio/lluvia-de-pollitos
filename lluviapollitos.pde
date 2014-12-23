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

//las dimensiones en las que el RA se llevarán a cabo.
public int arWidth = 1366, arHeight = 768; //480 360


// Para ubicar la posicion de la camara
public String camPara = "camera_para.dat";

//Rutas
//public String proyectPath = sketchPath("/home/fzzio/sketchbook/proyectos/lluviapollitos/");
public String proyectPath = "";

//Imagenes, Videos y Fuentes
int tamanoBebas = 160, tamanoTitan = 160;
public PFont fuenteBebas, fuenteTitan;
public Movie videoIntro;
public PImage[] imgObjetosError = new PImage[5];
public PImage[] imgNubes = new PImage[4];
public int posXNubes[] = {-200, 200, 900, 600};
public PImage imgBGSplash, imgBGMecanica, imgBGCampo, imgBGCielo, imgNidoA, imgNidoB, imgNidoVacio, imgContadorA, imgContadorB, imgGallina, imgPollo, imgPolloEnNido, imgTiempo, imgError, imgFlechaIzq, imgFlechaDer;


//Objeto de NYARTOOL
public MultiMarker nya;

//Estado del juego
public final int ESTADO_INTRO = 0, ESTADO_INSTRUCCIONES = 1, ESTADO_JUGANDO = 2, ESTADO_RESUMEN = 3, ESTADO_STAND_BY = 4;
public int estadoActualJuego = ESTADO_INTRO;


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
  


}

void stop(){
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
  }else if(key == '2'){
    estadoActualJuego = ESTADO_INSTRUCCIONES;
  }else if(key == '3'){
    estadoActualJuego = ESTADO_JUGANDO;
  }else if(key == '4'){
    estadoActualJuego = ESTADO_RESUMEN;
  }else if(key == '5'){
    estadoActualJuego = ESTADO_STAND_BY;
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
  pushMatrix();
    loadPixels();
    image(imgBGSplash, 0, 0, winWidth, winHeight);
  popMatrix();
}

// Pantalla con juego
public void verPantallaInstrucciones(){
  //println("Mostrando Instrucciones del juego");
  
  videoIntro.stop();
  pushMatrix();
    loadPixels();
    image(imgBGMecanica, 0, 0, winWidth, winHeight);
  popMatrix();

  float anchoPolloNuevo = imgPolloEnNido.width * 0.80;
  float altoPolloNuevo = imgPolloEnNido.height * 0.80;

  pushMatrix();
    loadPixels();
    image(imgPolloEnNido, ((winWidth - anchoPolloNuevo ) / 2), (((winHeight - altoPolloNuevo ) / 2) - 150 ), anchoPolloNuevo, altoPolloNuevo);
  popMatrix();
  
  pushMatrix();
    loadPixels();
    textFont(fuenteTitan, 100);
    textAlign(CENTER);
    fill(0, 157, 224);
    translate(((winWidth - anchoPolloNuevo ) / 2) + 100, ((winHeight - altoPolloNuevo ) / 2) + 230, 0);
    text("Mecánica", 0, 0);
    noFill();
  popMatrix();
  
  pushMatrix();
    loadPixels();
    textFont(fuenteBebas, 50);
    textAlign(CENTER);
    fill(21, 40, 132);
    translate(((winWidth - anchoPolloNuevo ) / 2) + 100, ((winHeight - altoPolloNuevo ) / 2) + 320, 0);
    text("Con el nido atrapa la mayor cantidad de\n pollitos que caen del cielo", 0, 0);
    noFill();
  popMatrix();
  
}


// Pantalla con juego
public void verPantallaJuego(){
  //println("Mostrando Juego");

  videoIntro.stop();
  
  // Dibujamos la interfaz
  dibujarInterfazJuego();

  


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
  popMatrix();
  
  pushMatrix();
    loadPixels();
    textFont(fuenteTitan, 80);
    textAlign(CENTER);
    fill(0, 157, 224);
    translate(((winWidth - anchoGallinaNuevo ) / 2) + 100, ((winHeight - altoGallinaNuevo ) / 2) + 230, 0);
    text("Fin del Juego", 0, 0);
    noFill();
  popMatrix();
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

  nya.addARMarker("patt/patt.hiro", 80);
  nya.addARMarker("patt/patt.kanji", 80);
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
  imgPollo = loadImage("img/pollito.png");
  imgPolloEnNido = loadImage("img/pollito-en-el-nido.png");
  
  imgTiempo = loadImage("img/time.png");
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
}
//////////////////////////////////////////////////////////////////////////////









//////////////////////////////////////////////////////////////////////////////
//    METODOS ADICIONALES PARA FUNCIONALIDAD
//////////////////////////////////////////////////////////////////////////////

// Llamado cada vez que un nuevo frame está disponible para leer
void movieEvent(Movie m) {
  m.read();
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
  popMatrix();


  // Para el campo
  pushMatrix();
    loadPixels();
    float altoCampoNuevo = imgBGCampo.height * 0.70;
    image(imgBGCampo, 0, abs(winHeight - altoCampoNuevo), winWidth, altoCampoNuevo);
  popMatrix();
}

//////////////////////////////////////////////////////////////////////////////
