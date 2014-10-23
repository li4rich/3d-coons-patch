/******** Editor of an Animated Coons Patch

Implementation steps:
**<01 Manual control of (u,v) parameters. 
**<02 Draw 4 boundary curves CT(u), CB(u), SL(v), CR(v) using proportional Neville
**<03 Compute and show Coons point C(u,v)
**<04 Display quads filed one-by-one for the animated Coons patch
**<05 Compute and show normal at C(u,v) and a ball ON the patch

*/
//**<01: mouseMoved; 'v', draw: uvShow()
float u=0, v=0; 
void uvShow() { 
  fill(red);
  if(keyPressed && key=='v')  text("u="+u+", v="+v,10,30);
  noStroke(); fill(blue); ellipse(u*width,v*height,5,5); 
  }


pt N(float a, pt A, float b, pt B, float t){
  return P((b-t)/(b-a),A).add(P((t-a)/(b-a),B));
}

pt N(float a, pt A, float b, pt B,float c, pt C, float t){
  pt P01 = N(a,A,b,B,t); 
  pt P12 = N(b,B,c,C,t);
  return P((c-t)/(c-a),P01).add(P((t-a)/(c-a),P12));
}

pt N(float a, pt A, float b, pt B,float c, pt C, float d, pt D, float t){
  pt P012 = N(a,A,b,B,c,C,t); 
  pt P123 = N(b,B,c,C,d,D,t);
  return P((d-t)/(d-a),P012).add(P((t-a)/(d-a),P123));
}

pt Lt0(float t, pt[] P){
  return N(0,P[0],1/3.0,P[1],2/3.0,P[2],1,P[3],t);
}

pt Lt1(float t, pt[] P){
  return N(0,P[9],1/3.0,P[8],2/3.0,P[7],1,P[6],t);
}

pt Lt(float t, float s, pt[] P){
  return L(Lt0(t,P),s,Lt1(t,P));
}

pt Ls0(float t, pt[] P){
  return N(0,P[0],1/3.0,P[11],2/3.0,P[10],1,P[9],t);
}

pt Ls1(float t, pt[] P){
  return N(0,P[3],1/3.0,P[4],2/3.0,P[5],1,P[6],t);
}

pt Ls(float s, float t, pt[] P){
  return L(Ls0(t,P),s,Ls1(t,P));
}

pt coons(pt[] P, float u, float v){
  pt corner = L(L(P[0],u,P[3]),v,L(P[9],u,P[6]));
  pt ls = Ls(u,v,P);
  pt lt = Lt(u,v,P);
  return lt.add(ls).add(P(-1,corner));
}

void shadeSurface(pt[] P, float e){ 
  for(float s=0; s<1.001-e; s+=e) for(float t=0; t<1.001-e; t+=e) 
  {beginShape(); v(coons(P,s,t)); v(coons(P,s+e,t)); v(coons(P,s+e,t+e)); v(coons(P,s,t+e)); endShape(CLOSE);}
  }
  
void drawBorders(pts P,pts Q, float e, boolean a, float h){
  for(float s=0; s<=1.00; s+=e){
    pen(green,1);
    show(N(0,P.G[0],1/3.0,P.G[1],2/3.0,P.G[2],1,P.G[3],s),N(0,P.G[0],1/3.0,P.G[1],2/3.0,P.G[2],1,P.G[3],s+e));
    show(N(0,P.G[3],1/3.0,P.G[4],2/3.0,P.G[5],1,P.G[6],s),N(0,P.G[3],1/3.0,P.G[4],2/3.0,P.G[5],1,P.G[6],s+e));
    show(N(0,P.G[6],1/3.0,P.G[7],2/3.0,P.G[8],1,P.G[9],s),N(0,P.G[6],1/3.0,P.G[7],2/3.0,P.G[8],1,P.G[9],s+e));
    show(N(0,P.G[9],1/3.0,P.G[10],2/3.0,P.G[11],1,P.G[0],s),N(0,P.G[9],1/3.0,P.G[10],2/3.0,P.G[11],1,P.G[0],s+e));
    pen(red,1);
    show(N(0,Q.G[0],1/3.0,Q.G[1],2/3.0,Q.G[2],1,Q.G[3],s),N(0,Q.G[0],1/3.0,Q.G[1],2/3.0,Q.G[2],1,Q.G[3],s+e));
    show(N(0,Q.G[3],1/3.0,Q.G[4],2/3.0,Q.G[5],1,Q.G[6],s),N(0,Q.G[3],1/3.0,Q.G[4],2/3.0,Q.G[5],1,Q.G[6],s+e));
    show(N(0,Q.G[6],1/3.0,Q.G[7],2/3.0,Q.G[8],1,Q.G[9],s),N(0,Q.G[6],1/3.0,Q.G[7],2/3.0,Q.G[8],1,Q.G[9],s+e));
    show(N(0,Q.G[9],1/3.0,Q.G[10],2/3.0,Q.G[11],1,Q.G[0],s),N(0,Q.G[9],1/3.0,Q.G[10],2/3.0,Q.G[11],1,Q.G[0],s+e));
    if (a){
      pts T = new pts();
      T.setToL(P,h,Q);
      pen(blue,1);
      show(N(0,T.G[0],1/3.0,T.G[1],2/3.0,T.G[2],1,T.G[3],s),N(0,T.G[0],1/3.0,T.G[1],2/3.0,T.G[2],1,T.G[3],s+e));
      show(N(0,T.G[3],1/3.0,T.G[4],2/3.0,T.G[5],1,T.G[6],s),N(0,T.G[3],1/3.0,T.G[4],2/3.0,T.G[5],1,T.G[6],s+e));
      show(N(0,T.G[6],1/3.0,T.G[7],2/3.0,T.G[8],1,T.G[9],s),N(0,T.G[6],1/3.0,T.G[7],2/3.0,T.G[8],1,T.G[9],s+e));
      show(N(0,T.G[9],1/3.0,T.G[10],2/3.0,T.G[11],1,T.G[0],s),N(0,T.G[9],1/3.0,T.G[10],2/3.0,T.G[11],1,T.G[0],s+e));
    }
  }
}


