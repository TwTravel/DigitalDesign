import java.io.FileOutputStream;
import java.io.PrintStream;

public class CameraOutput {
  public static void main(String [] args) throws Exception {
    FileOutputStream out_c = new FileOutputStream("camera.v");
    PrintStream c = new PrintStream(out_c);
    
    c.println("module camera(position_1, data);\n");
    c.println("input[2:0] position_1;\noutput reg[233:0] data;\n");
    
    c.println("always@(position_1)\nbegin");
    
    c.println("\tcase(position_1)");
    
    String fourbitI;
    int fourbitILength;
    
    float x = 0;
    float z = 0;
    
    ThreeTupleFloat e = new ThreeTupleFloat(0,0,0);
    ThreeTupleFloat g = new ThreeTupleFloat(0,0,0);
    ThreeTupleFloat u = new ThreeTupleFloat(0,0,0);
    ThreeTupleFloat v = new ThreeTupleFloat(0,0,0);
    ThreeTupleFloat w = new ThreeTupleFloat(0,0,0);
    ThreeTupleFloat t = new ThreeTupleFloat(0,1,0);
    
    for (int i = 0; i < 8; i++) {
      fourbitI = Integer.toBinaryString(i);
      fourbitILength = fourbitI.length();
     
      for (int j = 0; j < 3 - fourbitILength; j++)
        fourbitI = "0" + fourbitI;
      
      c.print("\t\t3'b" + fourbitI + ": ");
      
      x = (float)Math.sin(Math.PI * 2 * (i / 8f));
      z = (float)Math.cos(Math.PI * 2 * (i / 8f));
      
      g.x = -x;
      g.y = 0;
      g.z = -z;
      
      e.x = 10*x;
      e.y = 0;
      e.z = 10*z;
      
      w.x = -g.x / magnitude(g);
      w.y = 0;
      w.z = -g.z / magnitude(g);
      
      u = cross(t, w);
      u.x /= magnitude(cross(t,w));
      u.y /= magnitude(cross(t,w));
      u.z /= magnitude(cross(t,w));
      
      v = cross(w, u);
      
      //det = a11(a33a22-a32a23)-a21(a33a12-a32a13)+a31(a23a12-a22a13); we want 1 / det

      //    MV(Transpose)
      //    [    xu    xv    xw    ]
      //    [    yu    yv    yw    ]
      //    [    zu    zv    zw    ]

      float det = u.x * (w.z * v.y - v.z * w.y) - u.y * (w.z * v.x - v.z * w.x) + u.z * (w.y * v.x - v.y * w.x);
      
      det = 1f / det;
      
      System.out.println(det + "\t" + x + "\t" + z + "\t" + g + "\t" + u + "\t" + v + "\t" + w + "\t" + e);
      
      c.println("data = 234'b" + to18bitStringTuple(u) + to18bitStringTuple(v) + to18bitStringTuple(w) + to18bitStringTuple(e) + to18bitString(det) + ";");
    }
    c.println("\tendcase\nend\nendmodule");
    c.close();
  }
  
  public static String to18bitStringTuple(ThreeTupleFloat a) {
    return to18bitString(a.x) + to18bitString(a.y) + to18bitString(a.z);
  }
  
  public static float magnitude(ThreeTupleFloat a) {
    return (float)Math.sqrt(a.x*a.x + a.y*a.y + a.z*a.z);
  }
  
  public static ThreeTupleFloat cross(ThreeTupleFloat a, ThreeTupleFloat b) {
    return new ThreeTupleFloat(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
  }
  
  public static String to18bitString(float f) {
    int currentExponent = 0, exponentLength = 0;
    String exponent = "";
    
    if (f == 0) {
      return "000000000000000000";
    }
    else if (f < 0) {
      if (f > -0.5f) {
        while (f > -0.5f) {
          f *= 2.0f;
          currentExponent--;
        }
      }
            
      else {
        while ( f <= -1 ) {
          f /= 2.0f;
          currentExponent++;
        }
      }
            
      currentExponent += 128;
            
      exponent = Integer.toBinaryString(currentExponent);
      exponentLength = exponent.length();
            
      for (int l = 0; l < 8 - exponentLength; l++)
      exponent = "0" + exponent;
            
            
      int intbits = Float.floatToIntBits(f);
            
      //want bits 22-15, plus tack a 1 on the front
      intbits = intbits >> 15;
      intbits = intbits & 0x000000ff;
            
      intbits += 256;
            
      return "1" + exponent + Integer.toBinaryString(intbits);
    }
          
    else {
      if (f < 0.5f) {
        while (f < 0.5f) {
          f *= 2.0f;
          currentExponent-=1;
        }        
      }
      
      else {
        //exponent
        while ( f >= 1 ) {
          f /= 2.0d;
          currentExponent++;
        }
      }
            
      currentExponent += 128;
              
      exponent = Integer.toBinaryString(currentExponent);
      exponentLength = exponent.length();
              
      for (int l = 0; l < 8 - exponentLength; l++)
        exponent = "0" + exponent;
              
      int intbits = Float.floatToIntBits(f);
            
      //want bits 22-15, plus tack a 1 on the front
      intbits = intbits >> 15;
      intbits = intbits & 0x000000ff;
            
      intbits += 256;
      
      return "0" + exponent + Integer.toBinaryString(intbits);
    }
  }
}