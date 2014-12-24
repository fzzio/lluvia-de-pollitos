class Nido{
  private PImage imgNido;
  private int limiteMinX;
  private int limiteMaxX;
  private int posX;
  private int posY;
  
  Nido(){
    // Constructor vacio
  }

  Nido(int limiteMinX, int limiteMaxX){
    this();
    setLimiteMinX(limiteMinX);
    setLimiteMaxX(limiteMaxX);
    setPosY(height-imgNido.height);
    setPosX((getLimiteMaxX() - getLimiteMinX()) / 2);
  }
  
  Nido(PImage imgNido, int limiteMinX, int limiteMaxX){
    this();
    setImgNido(imgNido);
    setLimiteMinX(limiteMinX);
    setLimiteMaxX(limiteMaxX);
    setPosY(height-imgNido.height);
    setPosX((getLimiteMaxX() - getLimiteMinX()) / 2);
  }
  
  // Getters
  public PImage getImgNido(){
    return (this.imgNido);    
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
  
  // Setters
  public void setImgNido(PImage imgNido){
    this.imgNido = imgNido;
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
  
  // Medodos adicionales
  public void dibujarNido(int posX){
    pushMatrix();
      setPosX(posX);
      image(getImgNido(), getPosX(), getPosY());
    popMatrix();
  }
  
  public void dibujarNido(){
    pushMatrix();
      image(getImgNido(), getPosX(), getPosY());
    popMatrix();
  }  
  
  public void dibujarNido(int posX,int posY){
    pushMatrix();
      setPosX(posX);
      //setPosX(posY);
      image(getImgNido(), posX, getPosY());
    popMatrix();
  }
}
