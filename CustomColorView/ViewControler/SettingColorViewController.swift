//
//  SettingColorViewController.swift
//  CustomColorView
//
//  Created by user246073 on 9/13/24.
//

import UIKit

final class SettingColorViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet var screenColor: UIView!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTF: UITextField!
    @IBOutlet var greenTF: UITextField!
    @IBOutlet var blueTF: UITextField!
    
    var color: ColorProperty!
    weak var delegate: SettingColorViewControllerDelegate?
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        redSliderAction(redSlider)
        greenSliderAction(greenSlider)
        blueSliderAction(blueSlider)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if color != nil {
            updateColorAreaView()
        } else {
            print("Error: color is nil")
        }
    }
    // MARK: - IB Actions
    @IBAction func redSliderAction(_ sender: UISlider) {
        color.redProp = redSlider.value
        redLabel.text = string(from: redSlider)
        redTF.text = string(from: redSlider)
        updateColorAreaView()
    }
    
    @IBAction func greenSliderAction(_ sender: UISlider) {
        color.greenProp = greenSlider.value
        greenLabel.text = string(from: greenSlider)
        greenTF.text = string(from: greenSlider)
        updateColorAreaView()
    }
    
    @IBAction func blueSliderAction(_ sender: UISlider) {
        color.blueProp = blueSlider.value
        blueLabel.text = string(from: blueSlider)
        blueTF.text = string(from: blueSlider)
        updateColorAreaView()
    }
    
    @IBAction func doneSettingButton(_ sender: UIButton) {
        if let color = color {
            delegate?.setBackgroundColor(for: color)
        }
        dismiss(animated: true)
    }
    // MARK: - Private Methods
    private func setupUI() {
        guard let color = color else { return }
        redSlider.value = color.redProp
        greenSlider.value = color.greenProp
        blueSlider.value = color.blueProp
        
        redTF.text = string(from: redSlider)
        greenTF.text = string(from: greenSlider)
        blueTF.text = string(from: blueSlider)
        
        updateColorAreaView()
    }
    
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: false)
        return toolbar
    }
    
    private func updateColorAreaView() {
        guard let color = color else { return }
        let updatedColor = UIColor(
            red: CGFloat(color.redProp),
            green: CGFloat(color.greenProp),
            blue: CGFloat(color.blueProp),
            alpha: 1.0
        )
        screenColor.backgroundColor = updatedColor
    }
    
    private func string(from slider: UISlider) -> String{
        String(format: "%.2f", slider.value)
    }
    
}
//MARK: - UITextFieldDelegate
extension SettingColorViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let value = Float(text) else { return }
        
        switch textField {
        case redTF:
            color.redProp = value
            redSlider.setValue(value, animated: true)
            redLabel.text = text
        case greenTF:
            color.greenProp = value
            greenSlider.setValue(value, animated: true)
            greenLabel.text = text
        case blueTF:
            color.blueProp = value
            blueSlider.setValue(value, animated: true)
            blueLabel.text = text
        default:
            break
        }
        updateColorAreaView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Validation
    private func validateTextFieldInput(_ textField: UITextField) -> Bool {
        guard let text = textField.text, let value = Float(text) else {
            showAlert(title: "Ошибка", message: "Введите допустимое значение")
            return false
        }
        
        if value < 0.01 || value > 1.0 {
            showAlert(title: "Ошибка", message: "Значение должно быть от 0.01 до 1.0")
            return false
        }
        
        return true
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension Float {
    func cgFloat() -> CGFloat {
        CGFloat(self)
    }
}
