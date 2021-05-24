import Foundation
import UIKit
class SettingsViewController: UIViewController, UNUserNotificationCenterDelegate,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var notificationDate: UIDatePicker!
    var currentDateTime = Date();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        

    }
    @IBAction func notificationTime(_ sender: Any) {
        currentDateTime = notificationDate.date;
        print(currentDateTime);
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0;
    }
}





