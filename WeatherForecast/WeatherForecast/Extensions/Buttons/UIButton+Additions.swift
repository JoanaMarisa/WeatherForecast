//
//  UIButton+Additions.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 01/03/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import UIKit

extension UIButton {

    func setBackgroundImage(_ image: UIImage?) {
        
        setBackgroundImage(image, for: UIControl.State.highlighted)
        setBackgroundImage(image, for: UIControl.State.normal)
        
    }
    
}
