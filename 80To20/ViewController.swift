//
//  ViewController.swift
//  80To20
//
//  Created by Mike Stroner on 7/19/20.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate{

    @IBOutlet weak var batteryLabel: UILabel?;
    @IBOutlet var messageLabel: UILabel!;
    var batteryValue: Int = 0;
    
    private var observer : NSObjectProtocol?;
    
    let userNotificationCenter = UNUserNotificationCenter.current();
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.userNotificationCenter.delegate = self;
        
        checkBattery(batteryLevel: batteryValue);
        changeText();
        displayMessage(currentLevel: batteryValue);
        requestNotificationAuth();
        sendNotification();

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
    
    func requestNotificationAuth(){
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound);
        self.userNotificationCenter.requestAuthorization(options: authOptions) {(success, error) in
            if let error = error{
                print("Error: ", error);
            }
            
        }
    }
    
    
    func sendNotification()
    {
        let notificationContent = UNMutableNotificationContent();
        notificationContent.title = "Battery Level";
        notificationContent.body = "\(batteryValue)% ";
        notificationContent.badge = NSNumber(value:0);
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false); //Current Notification Trigger. 
        let request = UNNotificationRequest(identifier: "testNotification", content: notificationContent, trigger: trigger);
        
        
        userNotificationCenter.add(request) {(error) in
            if let error = error{
                print("Notification Error: ", error);
            }
        }
        
    }
    
    func displayMessage(currentLevel:Int)
    {
        messageLabel.textAlignment = .center;
        messageLabel.center.x = self.view.center.x;
        messageLabel!.font = UIFont(name:"Arial", size: 23.5);
        
        if(currentLevel == 80)
        {
            messageLabel.text = "Perfectly charged. Good job!";
        }
        else if(currentLevel >= 50 && currentLevel < 80)
        {
            messageLabel.text = "In a good place.";
        }
        else if(currentLevel < 50 && currentLevel > 20)
        {
            messageLabel.text = "Quickly approaching 20";
            messageLabel.center.x = self.view.center.x;
            
        }
        else{
            messageLabel.text = "Mission Critical. Please plug in.";
        }
        
       
    }
    
    
    
   
    


}

