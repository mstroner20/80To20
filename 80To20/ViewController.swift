//
//  ViewController.swift
//  80To20
//
//  Created by Mike Stroner on 7/19/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var batteryLabel: UILabel?;
    var batteryValue: Int = 0;
    
    private var observer : NSObjectProtocol?;
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkBattery(batteryLevel: batteryValue);
        changeText();

        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main){
            [unowned self] notification in
            checkBattery(batteryLevel: batteryValue);
        }
    }
    
    func checkBattery(batteryLevel : Int){
        UIDevice.current.isBatteryMonitoringEnabled = true;
        batteryValue = (Int)(UIDevice.current.batteryLevel * 100);
        batteryLabel!.text = "\(batteryValue)%";
    }
    
    func changeText(){
        batteryLabel!.center = self.view.center;
        batteryLabel!.textAlignment = .center;
        batteryLabel!.font = UIFont(name:"Arial", size: 45);
    }
    
    @IBAction func lowPowerSwitchonChange(_ sender: Any) {
        
        
        
    }
    
    
   
    


}

