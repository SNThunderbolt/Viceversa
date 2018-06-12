//
//  VictoryVC.swift
//  viceversa
//
//  Created by NouriMac on 6/3/18.
//  Copyright © 2018 SajedeNouri. All rights reserved.
//

import UIKit

class VictoryVC: UIViewController {


    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    @IBOutlet weak var image7: UIImageView!
    @IBOutlet weak var image8: UIImageView!
    @IBOutlet weak var image9: UIImageView!
    @IBOutlet weak var image10: UIImageView!
    @IBOutlet weak var image11: UIImageView!
    @IBOutlet weak var image122: UIImageView!
    
    @IBOutlet weak var restartBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restartBtn.isHidden = true
       

        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        let leftAnimation = AnimationType.from(direction: .left, offSet: 50.0)
        let rightAnimation = AnimationType.from(direction: .right, offSet: 30.0)
        let topAnimation = AnimationType.from(direction: .top, offSet: 100.0)
        let zoomInAnimation = AnimationType.zoom(scale: -0.2)
        let zoomInAnimation2 = AnimationType.zoom(scale: +0.2)
        let angle1 = AnimationType.rotate(angle: -0.3)
        let angle2 = AnimationType.rotate(angle: +0.8)
        
        UIView.animate(withDuration: 3) {
            self.image1.animate(withType: [leftAnimation, rightAnimation, zoomInAnimation, topAnimation, rightAnimation, angle1])
            self.image2.animate(withType: [zoomInAnimation, leftAnimation, leftAnimation, topAnimation, rightAnimation, angle2])
            self.image3.animate(withType: [leftAnimation, zoomInAnimation2, topAnimation, rightAnimation, angle1])
            self.image4.animate(withType: [zoomInAnimation, leftAnimation, topAnimation, rightAnimation, angle2])
            self.image5.animate(withType: [zoomInAnimation2, leftAnimation, topAnimation, rightAnimation, angle2])
            self.image6.animate(withType: [leftAnimation, topAnimation, rightAnimation, angle1, zoomInAnimation2])
            self.image7.animate(withType: [leftAnimation, zoomInAnimation, topAnimation, rightAnimation, angle1])
            self.image8.animate(withType: [leftAnimation, topAnimation, rightAnimation, angle1, zoomInAnimation2])
            self.image9.animate(withType: [leftAnimation, topAnimation, zoomInAnimation, rightAnimation, angle1])
            self.image10.animate(withType: [leftAnimation, topAnimation, rightAnimation, angle2, zoomInAnimation2])
            self.image11.animate(withType: [leftAnimation, topAnimation, rightAnimation, angle2, zoomInAnimation,])
            self.image122.animate(withType: [zoomInAnimation, leftAnimation, topAnimation, rightAnimation, angle1])
        }
        
        UIView.animate(withDuration: 1.0) {
            self.restartBtn.isHidden = false
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func restartBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
