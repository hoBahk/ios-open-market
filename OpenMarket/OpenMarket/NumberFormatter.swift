//
//  NumberFormatter.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/12.
//

import Foundation

struct CustomNumberFormatter {
  static var numberFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    
    return formatter
  }
  
  static func formatNumber(number: Int) -> String? {
    let result = numberFormatter.string(for: number)
    
    return result
  }
}

