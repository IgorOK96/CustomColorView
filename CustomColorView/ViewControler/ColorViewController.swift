//
//  ColorViewController.swift
//  CustomColorView
//
//  Created by user246073 on 9/13/24.
//

import UIKit

protocol SettingColorViewControllerDelegate: AnyObject {
    func setBackgroundColor(for colorProperty: ColorProperty)
}

final class ColorViewController: UIViewController {
    
    var color: ColorProperty!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let backgroundColor = self.view.backgroundColor {
            self.color = startColorProperties(from: backgroundColor)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let settingColorVC = segue.destination as? SettingColorViewController {
                settingColorVC.color = self.color
                settingColorVC.delegate = self
            }
        }
    
    func startColorProperties(from color: UIColor) -> ColorProperty? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return ColorProperty(
                redProp: Float(red),
                greenProp: Float(green),
                blueProp: Float(blue),
                alpha: Float(alpha)
            )
        } else {
            print("Не удалось извлечь компоненты цвета RGB")
            return nil
        }
    }
}
//MARK: - ColorPropertyDelegate
extension ColorViewController: SettingColorViewControllerDelegate {
    func setBackgroundColor(for colorProperty: ColorProperty) {
        self.color = colorProperty

        let color = UIColor(
            red: CGFloat(colorProperty.redProp),
            green: CGFloat(colorProperty.greenProp),
            blue: CGFloat(colorProperty.blueProp),
            alpha: CGFloat(colorProperty.alpha)
        )
        
        view.backgroundColor = color
    }
}

