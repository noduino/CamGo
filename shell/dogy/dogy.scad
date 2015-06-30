include <../lib/plus.scad>

thick=1.6+0.25+0.5;
w=61.22+0.25; //compasate 0.3
len=108+0.25;

$fn=60;

boxh=26; //internal
boxbh=12.5;
tb_thick=2; // top,bottom wall thick

module ethernet(quad=3) {
    // we go 'underground' as we need to poke space into the case
    color("silver") 
      Quad(21.12, 15.92, quad) 
       Cube(size=[21.12+6, 15.92+0.25, 13.3]);
}

module sma(){
    
   Cube(7,45,7);
}

module board(h){ //h: cut the box
  
  onboard=thick+1.15; //include the bottom pin
  //base pcb
  color("darkgreen")
     CubeR(w, len, h, r=0.5); //+15 for dig hole
  
  //eth port
  translate([w/2-12-15.92,len/2,onboard])//bottom pin 1.5
     rotate(90)
      ethernet();
    
  //ant
  for(p=[(w/2-7-12),-15.5])
     translate([p,-len/2,onboard])//z, on the board
       sma();
    
}


module holes(){

    translate([0, pad,2]) //board, 2: bootom thick
       //
       difference(){
         board(boxh);
      
       }
       
    // translate([0,7+pad-5,boxbh-2*pad]) //board
      //   Cube(w, len+5, boxh-boxbh-thick);
     
     translate([0,0])
       scatter_conner([w+9,len-7])
          up(-pad)hextraper();//screw mount
     /*
     translate([0,-len/2+3])
        translate([0,-150/2])
           up(-pad)Cube(150,150,50);//screw mount
     */
     translate([w/2,0])
         up(thick)CubeR(12,len-20,25, r=6);//screw mount
     translate([-w/2,0])
         up(thick)CubeR(12,len-20,25, r=6);//screw mount
       
    
}
module box(){
  wallthick=10;  
 
  difference(){
        //base
        union(){
        
            CubeR(w+wallthick*2, len+wallthick/2, boxh+tb_thick*2, r=6);

       }
    
    //holes
      difference(){
       holes();
       for (p=[0,15,30,45,-15,-30,-45])
           translate([0,p])
            Cube(w+50,1,boxh);
      }
   }

}

//testant();



module lid(){
    
  intersection(){
      box();
      up(boxbh-0.1)
        Cube(500,500,25);
  }
   
}

module blid(){
    
  difference(){
      box();
      up(boxbh)
        Cube(200,200,25);
  }
    
     
    
}

//box();
//blid();
//rotate([0,180])up(-boxh-tb_thick*2)
lid();



module testeth(){
intersection(){
  box();

 translate([0,len/2,0])
   Cube(w+5,20,33);

}

}



module testant(){
intersection(){
  box();
 translate([0,-len/2,0])
   Cube(w+5,18,44);

}

}


module hextraper(len=15){
    
    
          translate([0,0, 0])
         	    cylinder($fn=6, r2=(6.26+0.2)/2,r1=(6.26+0.7)/2, h=5);
          translate([0,0, 5+0.5])
		     	cylinder($fn=33, r=3.5/2, h=50);
           
          // sink screw
          //translate([0,0, -11.3])cylinder($fn=33, r2=3.4/2,r1=6.8/2, h=3);
          // screw slot
          translate([0,0,15])cylinder($fn=33, d=6.8,h=35);

}