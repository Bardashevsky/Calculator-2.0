//
//  ViewController.swift
//  Calculator 2.0
//
//  Created by Oleksandr Bardashevskyi on 4/1/19.
//  Copyright © 2019 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let backgroundView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "math")
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    let calculatorButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
        btn.setTitle("Calculator", for: .normal)
        btn.layer.borderWidth = 3
        btn.setTitle("Calculator", for: .highlighted)
        btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3659567637), for: .highlighted)
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.cornerRadius = 15
        btn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(calculatorAction), for: .touchUpInside)
        //btn.alpha = 0.7
        return btn
    }()
    @objc func calculatorAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        weak var viewController = storyboard.instantiateViewController(withIdentifier: "calculator")
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        view.window!.layer.add(transition, forKey: kCATransition)
        present(viewController!, animated: false, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        addBackgroundView()
        addButtons()
    }
    
    //MARK: - Constraint
    func addBackgroundView() {
        self.view.addSubview(backgroundView)
        self.backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.backgroundView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
    func addButtons() {
        self.view.addSubview(calculatorButton)
        self.calculatorButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.calculatorButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        self.calculatorButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.calculatorButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive = true
    }
}

