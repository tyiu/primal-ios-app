//
//  SunriseWave.swift
//  Primal
//
//  Created by Pavle D Stevanović on 23.5.23..
//

import UIKit

/// LIGHT DEFAULT THEME
final class SunriseWave: AppTheme {
    static let instance = SunriseWave()
    
    let kind: Theme = .sunriseWave
    
    let brandText: UIColor = .init(rgb: 0x444444)
    
    let background: UIColor = .init(rgb: 0xF5F5F5)
    let background2: UIColor = .init(rgb: 0xFFFFFF)
    let background3: UIColor = .init(rgb: 0xE5E5E5)
    let background4: UIColor = .init(rgb: 0xF5F5F5)
    
    let foreground: UIColor = .init(rgb: 0x111111)
    let foreground2: UIColor = .init(rgb: 0x111111)
    let foreground3: UIColor = .init(rgb: 0x666666)
    let foreground4: UIColor = .init(rgb: 0x808080)
    let foreground5: UIColor = .init(rgb: 0x808080)
    var foreground6: UIColor = .init(rgb: 0xC8C8C8)
    
    let accent: UIColor = .init(rgb: 0xCA079F)
    
    let extraColorMenu: UIColor = .init(rgb: 0x222222)
    
    var menuButtonImage: UIImage? { UIImage(named: "themeButtonLight") }
    
    var statusBarStyle: UIStatusBarStyle { .darkContent }
    var userInterfaceStyle: UIUserInterfaceStyle { .light }
    
    var mockupImage: UIImage? { UIImage(named: "readMockupLight") }
}
