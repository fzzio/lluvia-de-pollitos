class Pollo{
  private PImage imgPollo;
  private int limiteMinX;
  private int limiteMaxX;
  private int limiteMaxY;
  private int posX;
  private int posY;
  private float velocidad;
  private boolean cayendo;
  
  Pollo(){
    // constructor vacio
  }
  
  Pollo(PImage imgPollo, int limiteMinX, int limiteMaxX, int limiteMaxY){
    this();
    setImgPollo(imgPollo);
    setLimiteMinX(limiteMinX);
    setLimiteMaxX(limiteMaxX);
    setLimiteMaxY(limiteMaxY);
    setVelocidad(0);
    cayendo = false;
    setPosX((int)random(limiteMinX, limiteMaxX));
    setPosY(0);
  }
  
  // Getters
  public PImage getImgPollo(){
    return (this.imgPollo);    
  }
  
  public int getLimiteMinX(){
    return (this.limiteMinX);
  }
  
  public int getLimiteMaxX(){
    return (this.limiteMaxX);
  }
  
  public int getPosX(){
    return (this.posX);
  }
  
  public int getPosY(){
    return (this.posY);
  }

  public int getLimiteMaxY(){
    return (this.limiteMaxY);
  }
  
  public float getVelocidad(){
    return (this.velocidad);
  }
  
  public boolean estaCayendo(){
    return (this.cayendo);
  }
  
  // Setters
  public void setImgPollo(PImage imgPollo){
    this.imgPollo = imgPollo;
  }
  
  public void setLimiteMinX(int limiteMinX){
    this.limiteMinX = limiteMinX;
  }
  
  public void setLimiteMaxX(int limiteMaxX){
    this.limiteMaxX = limiteMaxX;
  }
  
  public void setPosX(int posX){
    this.posX = posX;
  }
  
  public void setPosY(int posY){
    this.posY = posY;
  }

  public void setLimiteMaxY(int limiteMaxY){
    this.limiteMaxY = limiteMaxY;
  }
  
  public void setVelocidad(float velocidad){
    this.velocidad = velocidad;
  }
  
  public void iniciarCaida(){
    this.cayendo = true;
  }
  
  public void detenerCaida(){
    this.cayendo = true;
  }
  
  // Medodos adicionales
  public void dibujarPollo(){
    pushMatrix();
      image(getImgPollo(), getPosX(), getPosY());
    popMatrix();
  }
  
  public boolean llegoAlPiso(){
    if (getPosY() >= getLimiteMaxY()){
      return true;
    }else{
      return false;
    }
  }
  
  // realiza el movimiento de caida del pollo aumentando la coordenada en Y
  public void caer(){
    int y = getPosY();
    y = y + (int)velocidad;
    if(y < height){
      setPosY(y);
    }
  }
}
