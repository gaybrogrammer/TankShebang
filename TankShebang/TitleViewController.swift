//
//  TitleViewController.swift
//  TankShebang
//
//  Created by Robert Beit on 12/1/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {
var Music = String()
    var Sound = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "options"){
        }
        if(segue.identifier == "select"){
            var game_options = segue.destination as! PlayerSelectViewController
            
            game_options.Music = Music
            game_options.Sound = Sound
        }
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
