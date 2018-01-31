/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bicycle;


public class BicycleId {
    
    
    static int numberOfBicycles = 0;
    private int id;
    
    public BicycleId(int i){
        id = ++numberOfBicycles;
    }
    
    public int getID(){
        return id;
    }
    
}
