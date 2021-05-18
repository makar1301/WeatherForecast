//
//  CustomTabBar.swift
//  WheatherForecastTest
//
//  Created by mac on 14.05.2021.
//

import Foundation
import UIKit

class CustomTabBar: UITabBarController, UITabBarControllerDelegate {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        setupMiddleButton()
    }
    
    func setupMiddleButton() {
        
        let middleButton = UIButton(frame: CGRect(x: self.view.bounds.width/2 - 35, y: -20, width: 70, height: 70))
    
        middleButton.backgroundColor = UIColor.blue
        middleButton.setImage(UIImage(systemName: "plus"), for: .normal)
        middleButton.layer.cornerRadius = 35
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.3
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        self.tabBar.addSubview(middleButton)
        
        
        middleButton.addTarget(self, action: #selector(mainVC), for: .touchUpInside)
        
        self.view.layoutIfNeeded()
    }
    
    @objc func mainVC(sender: UIButton) {
        let alert = UIAlertController(title: "Просто кнопка!", message: "Т.к на данную кнопку не просили добавить функционал, то если вы видите это сообщение, значит она работает!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Молодец!", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
