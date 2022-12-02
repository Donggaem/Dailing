//
//  DailingLog.swift
//  Dailing
//
//  Created by 김동겸 on 2022/12/02.
//

import Foundation

final public class DailingLog {
  
  public class func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    let output = items.map { "\($0)" }.joined(separator: separator)
    print("💚 [\(getCurrentTime())] Dailing - \(output)", terminator: terminator)
    #else
    print("💚 [\(getCurrentTime())] Dailing - RELEASE MODE")
    #endif
  }
  
  public class func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    let output = items.map { "\($0)" }.joined(separator: separator)
    print("🚨 [\(getCurrentTime())] Dailing - \(output)", terminator: terminator)
    #else
    print("🚨 [\(getCurrentTime())] Dailing - RELEASE MODE")
    #endif
  }
  
  
  
  
  fileprivate class func getCurrentTime() -> String {
    let now = NSDate()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return dateFormatter.string(from: now as Date)
  }
}
