class Nido{
  private PImage imgNido;
  private int limiteMinX;
  private int limiteMaxX;
  private int posX;
  private int posY;
  private float error;
  
  Nido(){
    // Constructor vacio
  }

  Nido(int limiteMinX, int limiteMaxX){
    this();
    setLimiteMinX(limiteMinX);
    setLimiteMaxX(limiteMaxX);
    setPosY(height-imgNido.height);
    setPosX( getLimiteMinX() );
  }
  
  Nido(PImage imgNido, int limiteMinX, int limiteMaxX){
    this();
    setImgNido(imgNido);
    setLimiteMinX(limiteMinX);
    setLimiteMaxX(limiteMaxX);
    setPosY(height-imgNido.height);
    setPosX( getLimiteMinX() );
  }
  
  // Personalizado por la imagen de error
  Nido(PImage imgNido, int limiteMinX, int limiteMaxX, float proporcion){
    this();
    setImgNido(imgNido);
    
    //setError(  ( getImgNido().width * proporcion ) / 4  );
    //setLimiteMinX(limiteMinX -  (int)getError() );
    //setLimiteMaxX(limiteMaxX -  (int)getError() );
    
    setLimiteMinX(limiteMinX);
    setLimiteMaxX(limiteMaxX);
    setPosY(height - (int)(imgNido.height * proporcion - 35));
    setPosX( getLimiteMinX() );
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
  
  public void setError(float error){
    this.error = error;
  }
  
  public float getError(){
    return (this.error);
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
    if(posX >= getLimiteMinX() && posX <= getLimiteMaxX() ){
      setPosX(posX);
    }
    pushMatrix();
      image(getImgNido(), getPosX(), getPosY());
    popMatrix();
  }
  
  public void dibujarNido(int posX, float proporcion){
    if(posX >= getLimiteMinX() && posX <= getLimiteMaxX() ){
      setPosX(posX);
    }

    pushMatrix();
      image(getImgNido(), getPosX(), getPosY(), getImgNido().width * proporcion, getImgNido().height * proporcion);
    popMatrix();
  }
  
  public void dibujarNido(){
    pushMatrix();
      image(getImgNido(), getPosX(), getPosY());
    popMatrix();
  }  
  
  public void dibujarNido(int posX,int posY){
    if(posX >= getLimiteMinX() && posX <= getLimiteMaxX() ){
      setPosX(posX);
      //setPosX(posY);
    }
    pushMatrix();
      image( getImgNido(), posX, getPosY() );
    popMatrix();
  }
  
  public void dibujarNido(int posX,int posY, float proporcion){
    if(posX >= getLimiteMinX() && posX <= getLimiteMaxX() ){
      setPosX(posX);
      //setPosX(posY);
    }
    pushMatrix();
      image( getImgNido(), getPosX(), getPosY(), getImgNido().width * proporcion, getImgNido().height * proporcion);
    popMatrix();
  }
  
  public void dibujarNido(float proporcion){
    pushMatrix();    
      //println("Pos X: " + getPosX() + " - Pos Y: " + getPosY() + " - Proporcion Ancho: " + getImgNido().width * proporcion + " - Proporcion Alto: " + getImgNido().height * proporcion );
      image(getImgNido(), getPosX(), getPosY(), getImgNido().width * proporcion, getImgNido().height * proporcion);
    popMatrix();
  }  
  
  public String toString(){
    return("Limite Min X: " + getLimiteMinX() + " - Limite Max X: " + getLimiteMaxX() + " - Pos X: " + getPosX() + " - Pos Y: " + getPosY() );
  }
}