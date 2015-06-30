


pad=0.05; /*make sure no malform or wrong object*/


green=[0.1,0.9,0.2,0.8];
black=[0.3,0.3,0.3,1];

fgreen=[0.3, 0.9, 0.2, 0.95];
fgold=[1,0.85, 0.1, 0.95];
fblue=[0.2,0.2,0.79];

//position helper
function cot(x)=1/tan(x);

module up(z){
    translate([0,0,z])
      children();
}

//basic shape 
module Cube(x,y,z,size){
  

   //echo("size", size);
   if(size){
     translate([0,0,size[2]/2])
       cube(size,center=true);
   }else{
     translate([0,0,z/2])
       cube([x,y,z],center=true);
     
   }


}

//test
//Cube(13,13,3);

module chamfer_cylinder(r,d,h,ch,crt,cdt,cdb,crb)
{
 	union(){
		 translate([0,0,h-ch])
	    	 cylinder(r1=r,d1=d, r2=crt,d2=cdt,h=ch);
         translate([0,0,ch])
  	       cylinder(r=r,d=d,h=h-ch*2);
         cylinder(r2=r,d2=d, r1=crb,d1=cdb,h=ch);
	}
}

module M3HexScrew(len=10, r=3){
      chamfer_cylinder(r=r/2,h=len-2*2, ch=2,crt=r/2,crb=7/2);
}


//chamfer_cylinder(r=10, h=10, crt=15,crb=15,ch=3);




/////////////////////////////////////////////////////////
// position helper
module quadI(x, y){
    translate([x/2, y/2]){
       children();    
    }
}
module quadII(x, y){
    translate([-x/2, y/2]){
       children(); 
    }
}
module quadIII(x, y){
    translate([-x/2, -y/2]){
       children();    
    }
    
}
module quadIV(x, y){
    translate([x/2, -y/2]){
       children();    
    }
}
module Quad(x, y, quad=0){

   if(quad==1)
       quadI(x,y)
            children();
   if(quad==2)
       quadII(x,y)
            children(); 
   if(quad==3)
       quadIII(x,y)
            children(); 
   if(quad==4)
       quadIV(x,y)
        children(); 

}
/////////////////////////////////////////////////////////
module scatter_conner(size=[0,0,0]){
    /*given x,y, (z) get 4 corner coordinates
                 Y
                /
          [2,  / 1]
         -----+---->X
         [3, /   4]
    */
    x=size[0]/2.0;
    y=size[1]/2.0;
    z=size[2];
    vet=[[ x,  y, z],
            [-x,  y, z],
            [-x, -y, z],
            [ x, -y, z]
        ];
    for (v=vet)
       translate(v)
          children();
}

/////////////////////////////////////////////////////////

module Sphere(r=none, d=none){
  if(r)
     translate([0,0,r])
     sphere(r=r);
  else
     translate([0,0,d/2]) 
     sphere(d=d);
}

//Sphere(d=3);




module CubeR(x,y,z,r){ CubeRZ(x=x,y=y,z=z,r=r);}
module CubeRZ(x,y,z,r){ CubeRXYZ(x=x,y=y,z=z,rz=r);}
module CubeRY(x,y,z,r){ CubeRXYZ(x,y,z,ry=r);}
module CubeRX(x,y,z,r){ CubeRXYZ(x,y,z,rx=r);}
module CubeRR(x,y,z,r){CubeRXYZ(x=x,y=y,z=z,rx=r,ry=r,rz=r,rc=r);}
module CubeRXYZ(x,y,z,r,rx,ry,rz,rc){
    difference(){
        Cube(x=x,y=y,z=z);
        //z
        if(rz)
        for(q=[1:4])
          Quad(x,y,q) up(-pad) 
           _RoundSmooth(l=z+pad*2,r=rz);
        //y
        if(ry){
            for(q=[1:2])
              Quad(x,y,q) up(-pad)
                rotate([90,0,0])up(-pad)_RoundSmooth(l=y+2*pad,r=ry);
            for(q=[3:4])
               Quad(x,y,q)translate([0,y,z])
                rotate([90,0,0])up(-pad)_RoundSmooth(l=y+2*pad,r=ry);
        }
        //x
        if(rx){
            for(q=[2,3])
                Quad(x,y,q) up(-pad)
                  rotate([0,90,0])up(-pad)_RoundSmooth(l=x+2*pad,r=rx);
            for(q=[1,4])
                Quad(x,y,q) translate([-x,0,z])
                  rotate([0,90,0])up(-pad)_RoundSmooth(l=x+2*pad,r=rx);
       }
       
       if(rc){
        for(q=[1,2,3,4])
          Quad(x,y,q)
            _RoundSmoothConner(rc);
          for(q=[1,2,3,4])
          Quad(x,y,q)
            up(z)
            _RoundSmoothConner(rc);
       }
  }
    
}

module _RoundSmoothConner(r){
    translate([0,0,-r])
    difference() {
        Cube(r*2, r*2, r*2);
        
        for(q=[1:4])
          Quad(2*r,2*r,q)
            sphere(r);
        for(q=[1:4])
          up(2*r)
           Quad(2*r,2*r,q)
             sphere(r+pad);
     }
 }
//$fn=45;
//_RoundSmoothConner(r=5);
 module _RoundSmooth(r, l){
   //translate([-r,-r,0])
   difference(){
    Cube(2*r, 2*r, l);
     for(q=[1:4])
       Quad(2*r-pad,2*r-pad,q) //pad: critical for export water tight
           up(-pad)cylinder(r=r,h=l+2*pad);
   }
}
//CubeR(5,5,5,r=1);

//speed test
//for(i=[1:50]) translate([i*10,0,0]) %_CubeFR_(10,5*i,5, r=2);
//for(i=[1:50])translate([i*10,0,0]) %CubeR(10,5*i,5,r=2);

module Hex(width,thick){
  
  angle = 360/6;		// 6 pans
  side = width*cot(angle);
  for (i=[0,60, 120])
    rotate(i)  
       Cube(side,width,thick);
    
}


///////////////////////////////////////////////
//dropped 
module CubeR__slow(x,y,z,r){
  size=[x-2*r, y-2*r, 0];  
  
  hull(){
    scatter_conner(size)
       cylinder(r=r, h=z);  
  }   
    
}


