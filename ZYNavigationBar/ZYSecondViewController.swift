//
//  ZYSecondViewController.swift
//  ZYNavigationBar
//
//  Created by yu zhou on 13/09/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYSecondViewController: UIViewController {
    
    var tttttt = 0
    let barTintColors = [UIColor.green,UIColor.yellow,UIColor.red,UIColor.blue]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.zy_barTintColor = barTintColors[tttttt]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func button(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
