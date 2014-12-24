class Objeto{
  private PImage imgObjeto;
  private int limiteMinX;
  private int limiteMaxX;
  private int limiteMaxY;
  private int posX;
  private int posY;
  private float velocidad;
  private boolean cayendo;
  
  Objeto(){
    // constructor vacio
  }
  
  Objeto(PImage imgObjeto, int limiteMinX, int limiteMaxX, int limiteMaxY){
    this();
    setImgObjeto(imgObjeto);
    setLimiteMinX(limiteMinX);
    setLimiteMaxX(limiteMaxX);
    setLimiteMaxY(limiteMaxY);
    setVelocidad(0);
    cayendo = false;
    setPosX((int)random(limiteMinX, limiteMaxX));
    setPosY(0);
  }
  
  // Getters
  public PImage getImgObjeto(){
    return (this.imgObjeto);    
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
  public void setImgObjeto(PImage imgObjeto){
    this.imgObjeto = imgObjeto;
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
  public void dibujarObjeto(){
    pushMatrix();
      image(getImgObjeto(), getPosX(), getPosY());
    popMatrix();
  }
  
  public boolean llegoAlPiso(){
    if (getPosY() >= getLimiteMaxY()){
      return true;
    }else{
      return false;
    }
  }
  
  // realiza el movimiento de caida del Objeto aumentando la coordenada en Y
  public void caer(){
    int y = getPosY();
    y = y + (int)velocidad;
    if(y < height){
      setPosY(y);
    }
  }
}
