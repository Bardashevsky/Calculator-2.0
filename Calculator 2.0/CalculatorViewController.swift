//
//  CalculatorViewController.swift
//  Calculator 2.0
//
//  Created by Oleksandr Bardashevskyi on 4/1/19.
//  Copyright © 2019 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    enum ButtonTagValue: Int {
        case Zero, One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Dot, Equally, Plus, Minus, Multiplication, Division, Percent, PlusMinus, Delete
    }
    @IBOutlet var operationOutletCollection: [UIButton]!
    @IBOutlet var numbersOutletCollection: [UIButton]!
    @IBOutlet weak var deleteOutlet: UIButton!
    @IBOutlet weak var dot: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var markTextView: UITextView!
    
    //MARK: - Variables
    var outputText: String = "0" {
        didSet {
            if outputText.count > 12 {
                outputText = oldValue
            }
        }
    }
    var newNumber = false
    var firstNumber: Double = 0
    var secontNumber: Double = 0
    var result: Double = 0
    var operation = Int()
    var deskUserDefaultKey = "kDeskText"
    var backButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Menu", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        btn.layer.borderWidth = 2
        btn.layer.borderColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(actionBack), for: .touchUpInside)
        return btn
    }()
    @objc func actionBack() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(markTextView.text, forKey: deskUserDefaultKey)
        dismiss(animated: true, completion: nil)
    }
    var clearDeskButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Clear", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
        btn.layer.borderWidth = 2
        btn.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(actionClearDesk), for: .touchUpInside)
        return btn
    }()
    @objc func actionClearDesk() {
        markTextView.font = UIFont(name: "Chalkduster", size: 15)
        markTextView.textColor = UIColor.lightGray
        markTextView.text = "Tap to enter your text..."
    }
    let backgroundView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "math")
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return view
    }()
    let hideKeyboardButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont(name: "Chalkduster", size: 15)
        btn.setTitle("End editing", for: .normal)
        btn.addTarget(self, action: #selector(hideKeyboardAction), for: .touchUpInside)
        btn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        btn.setTitleColor(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), for: .normal)
        btn.layer.cornerRadius = 15
        btn.layer.borderColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        btn.layer.borderWidth = 1
        return btn
    }()
    @objc func hideKeyboardAction () {
        markTextView.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundView()
        buttonsLookFormator()
        addBackAndClearButtons()
        
        let userDefaults = UserDefaults.standard
        markTextView.text = userDefaults.object(forKey: deskUserDefaultKey) as? String
    }
    //MARK: - Add Back & Clear buttons
    func addBackAndClearButtons() {
        self.view.addSubview(backButton)
        self.view.addSubview(clearDeskButton)
        
        backButton.bottomAnchor.constraint(equalTo: self.markTextView.topAnchor, constant: -5).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.markTextView.leftAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        clearDeskButton.bottomAnchor.constraint(equalTo: self.markTextView.topAnchor, constant: -5).isActive = true
        clearDeskButton.rightAnchor.constraint(equalTo: self.markTextView.rightAnchor).isActive = true
        clearDeskButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        clearDeskButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    //MARK: - Add value from label to textView
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! //первый тач одного пальца
        let pointOnMainView = touch.location(in: self.view)
        
        if label.frame.contains(pointOnMainView) {
            markTextView.font = UIFont(name: "Chalkduster", size: 30)
            markTextView.textColor = .white
            if markTextView.text == "Tap to enter your text..." {
                markTextView.text = ""
            }
            markTextView.text.append(markTextView.text.hasSuffix(" ") ? label.text! : " " + label.text!)
        }
    }
    //MARK: - Actions
    
    @IBAction func actionNumbers(_ sender: UIButton) {
        if outputText == "0" {
            outputText = ""
        }
        if newNumber == true {
            outputText = String(sender.tag)
            newNumber = false
        } else {
            outputText.append(String(sender.tag))
        }
        secontNumber = Double(outputText) ?? 0
        self.label.text = outputText
    }
    @IBAction func actionClear(_ sender: UIButton) {
        outputText = "0"
        label.text = outputText
    }
    @IBAction func actionDot(_ sender: UIButton) {
        if !outputText.contains(".") {
            outputText.append(".")
            label.text = outputText
        }
    }
    @IBAction func actionPlusMinus(_ sender: UIButton) {
        if !outputText.contains("-") {
            outputText.insert("-", at: outputText.startIndex)
            label.text = outputText
        } else {
            outputText.removeFirst()
            label.text = outputText
        }
    }
    @IBAction func actionOperatios(_ sender: UIButton) {
        if outputText != "" {
            if sender.tag != ButtonTagValue.Equally.rawValue {
                firstNumber = Double(label.text!)!
                operation = sender.tag
                newNumber = true
            } else {
                secontNumber = Double(outputText)!
                switch operation {
                case ButtonTagValue.Plus.rawValue:
                    result = firstNumber + secontNumber
                    label.text = formatResult(number: result)
                    newNumber = true
                case ButtonTagValue.Minus.rawValue:
                    result = firstNumber - secontNumber
                    label.text = formatResult(number: result)
                    newNumber = true
                case ButtonTagValue.Multiplication.rawValue:
                    result = firstNumber * secontNumber
                    label.text = formatResult(number: result)
                    newNumber = true
                case ButtonTagValue.Division.rawValue:
                    result = firstNumber / secontNumber
                    label.text = formatResult(number: result)
                    newNumber = true
                case ButtonTagValue.Percent.rawValue:
                    result = secontNumber * firstNumber / 100
                    label.text = formatResult(number: result)
                    newNumber = true
                default:
                    break
                }
            }
        }
    }
    //MARK: - FormatString
    func formatResult(number: Double) -> String {
        return Double(Int(number)) == Double(number) ? String(Int(number)) : String(Double(number))
    }
    
    //MARK: - Constraint
    func addBackgroundView() {
        self.view.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)
        self.backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.backgroundView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
    
    //MARK: Button Looks Formate
    func buttonsLookFormator() {
        for i in numbersOutletCollection {
            i.layer.cornerRadius = 15
            i.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            i.setTitleColor(#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1), for: .normal)
            i.titleLabel?.font = UIFont(name: "Chalkduster", size: 20)
        }
        for i in operationOutletCollection {
            i.layer.cornerRadius = 15
            i.backgroundColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
            i.setTitleColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), for: .normal)
            i.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
        }
        dot.layer.cornerRadius = 15
        dot.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        dot.setTitleColor(#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1), for: .normal)
        dot.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
        
        deleteOutlet.layer.cornerRadius = 15
        deleteOutlet.backgroundColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
        deleteOutlet.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
        
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        label.font = UIFont(name: "BradleyHandITCTT-Bold", size: 40)
        label.layer.borderWidth = 5
        label.layer.borderColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
        
        markTextView.backgroundColor = .black
        markTextView.layer.borderWidth = 5
        markTextView.layer.borderColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        markTextView.font = UIFont(name: "Chalkduster", size: 15)
        markTextView.text = "Tap to enter your text..."
        markTextView.textColor = UIColor.lightGray
        
        
    }
    //MARK: - Constraints
    func addButtonForHideKeyboard() {
        self.view.addSubview(hideKeyboardButton)
        
        hideKeyboardButton.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 10).isActive = true
        hideKeyboardButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        hideKeyboardButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        hideKeyboardButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}


extension CalculatorViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if markTextView.text == "Tap to enter your text..." {
            markTextView.text = ""
        }
        markTextView.font = UIFont(name: "Chalkduster", size: 30)
        markTextView.textColor = UIColor.white
        UIView.animate(withDuration: 0.5) {
            for i in self.numbersOutletCollection {
                i.alpha = 0
            }
            for i in self.operationOutletCollection {
                i.alpha = 0
            }
            self.deleteOutlet.alpha = 0
            self.dot.alpha = 0
        }
        addButtonForHideKeyboard()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if markTextView.text.isEmpty {
            markTextView.font = UIFont(name: "Chalkduster", size: 15)
            markTextView.text = "Tap to enter your text..."
            markTextView.textColor = UIColor.lightGray
        }
        hideKeyboardButton.removeFromSuperview()
        UIView.animate(withDuration: 0.5) {
            for i in self.numbersOutletCollection {
                i.alpha = 1
            }
            for i in self.operationOutletCollection {
                i.alpha = 1
            }
            self.deleteOutlet.alpha = 1
            self.dot.alpha = 1
        }
    }
    
}
