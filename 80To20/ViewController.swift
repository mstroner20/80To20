//
//  ViewController.swift
//  80To20
//
//  Created by Mike Stroner on 7/19/20.
//
/*
 
 TODO
 --------
 -Change the bottom text sizing and formatting to allow it to be seen -FIXED
 -Add an icon to explain the limitations of the app with background updating
 -Add settings tab that allows the user to choose time intervals on notifications.
    -Time in hours to be notified per day.
 */

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate{

    @IBOutlet weak var batteryLabel: UILabel?;
    @IBOutlet var messageLabel: UILabel!;
    
    private var observer : NSObjectProtocol?;
    var batteryValue: Int = 0;

    let userNotificationCenter = UNUserNotificationCenter.current();
   
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.isBatteryMonitoringEnabled = true; //Enable battery monitoring every load.
        self.userNotificationCenter.delegate = self;
        
        checkBattery(); //Checks the battery level
        displayMessage(currentLevel: batteryValue); //Displays the bottom text to let the user known the state of their battery charge.
        requestNotificationAuth(); //Request the first notification auth
        sendNotification();        //Sends the notifications

        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main){   //Creates an observer
            [unowned self] notification in
            checkBattery();
        }
     
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange(notification:)), name: UIDevice.batteryLevelDidChangeNotification, object: nil); //Allows for real-time updating of the label
    }
    //On battery level change
    @objc func batteryLevelDidChange(notification: NSNotification){
        checkBattery(); //Update the label
        
    }
    //Check the current charge of the battery level
    func checkBattery(){
        
        batteryValue = (Int)(UIDevice.current.batteryLevel * 100); //Get the float value from the device then convert to Int value without leading 0s
        batteryLabel!.text = "\(batteryValue)%";    //Add battery level to label
        
        batteryLabel!.center = self.view.center;    //Centers the label on the screen
        batteryLabel!.textAlignment = .center;      //Centers the label within the label bounds
        batteryLabel!.font = UIFont(name:"Arial", size: 45);    //Font size and type
    }
    //Requests the first notification authorization on first launch
    func requestNotificationAuth(){
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound);
        self.userNotificationCenter.requestAuthorization(options: authOptions) {(success, error) in
            if let error = error{
                print("Error: ", error);
            }
            
        }
    }
    
    //Sends notifications while app is in background based on time. -NEEDS WORK
    func sendNotification()
    {
        let notificationContent = UNMutableNotificationContent();
        notificationContent.title = "Battery Level";    //Title of the notification
        notificationContent.body = "\(batteryValue)% "; //Text of the notification
        notificationContent.badge = NSNumber(value:0);  //Badge number when notification is triggered. Badge == red number on app icon after notif is triggered
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false);  //Current Notification Trigger. Repeats every minute but does not repeat
        let request = UNNotificationRequest(identifier: "testNotification", content: notificationContent, trigger: trigger);    //Actual sending of the notification.
        
        
        userNotificationCenter.add(request) {(error) in
            if let error = error{
                print("Notification Error: ", error);
            }
        }
        
    }
    
    func displayMessage(currentLevel:Int)
    {
        //Align the bottom text -NEEDS WORK
        messageLabel.textAlignment = .center;
        messageLabel.center.x = self.view.center.x;
        messageLabel!.font = UIFont(name:"Arial", size: 23.5);
        
        //Changes message depending on battery level percentage.
        if(currentLevel == 80)
        {
            messageLabel.text = """
            Perfectly charged.
            Good job!
            """;
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
            messageLabel.text =
            """
            Mission Critical.
            Please plug in.";
            """
        }
        
       
    }
    
    
    
    
    
   
    


}

