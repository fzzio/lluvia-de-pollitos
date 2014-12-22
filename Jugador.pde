/* Clase Jugador para manejar todos los eventos que tengan que
  ver con un jugador. */
class Jugador{
  private int puntos;
  private int velocidad;
  
  Jugador(){
    setPuntos(0);
    setVelocidad(2);
  }
  
  // Getters
  public int getPuntos(){
    return (this.puntos);
  }
  
  public int getVelocidad(){
    return (this.velocidad);
  }
  
  // Setters
  public void setPuntos(int puntos){
    this.puntos = puntos;
  }

  public void setVelocidad(int velocidad){
    this.velocidad = velocidad;
  }
  
  public void aumentarPuntos(){
    this.puntos = this.puntos + 1;
  }
  
  public void reducirPuntos(){
    this.puntos = this.puntos - 1;
    if (this.puntos < 0){
      this.puntos = 0;
    }
  }
  
  public void aumentarVelocidad(){
    // esta es la velocidad que maneja cada uno
    this.velocidad = this.velocidad + 1;
  }
}
