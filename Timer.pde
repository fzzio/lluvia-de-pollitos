class Timer {
 
  int savedTime; // Cuando empezo el Timer
  int totalTime; // Cuanto deberia durar el Timer
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }
  
  // Inicia el timer
  void start() {
    // Cuando inicia el timer se almacenan los milisegundos
    savedTime = millis(); 
  }
  
  boolean isFinished() { 
    // verifica que se haya finalizado el timer
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
  
  // Se modifico esta clase agregando estos metodos
  int getTiempoTranscurrido(){
    return (millis()- savedTime);
  }
  
  int getSegundosTranscurridos(){
    return ((millis()- savedTime) / 1000);
  }
  
  int getTiempoRestante(){
    int passedTime = millis()- savedTime;
    return (totalTime - passedTime);
  }
  
  int getSegundosRestantes(){
    return (getTiempoRestante() / 1000);
  }
}
