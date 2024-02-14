//
//  ViewController.swift
//  AMSlider-Demo
//
//  Created by Seb Vidal on 13/02/2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let slider = AMSlider()
        slider.tintColor = .label
        slider.trackingMode = .absolute
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        view.addSubview(slider)
        
        NSLayoutConstraint.activate([
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func sliderValueChanged(_ sender: AMSlider) {
        print(sender.progress)
    }
}
