//
//  Direction.swift
//  LOFI
//
//  Created by TuanNM on 11/2/17.
//  Copyright © 2017 Nguyen Manh Tuan. All rights reserved.
//

import UIKit

enum Direction{
    case NON
    case UP
    case DOWN
    case LEFT
    case RIGHT
    case UP_LEFT
    case UP_RIGHT
    case DOWN_RIGHT
    case DOWN_LEFT
}

class Utils{

    static let offSet:CGFloat = 5
    
    static func getDirectionAdvance(prevLocation:CGPoint,currentLocation:CGPoint) -> Direction{
        if abs(prevLocation.x - currentLocation.x) > 10 || abs(prevLocation.y - currentLocation.y) > 10{
            
            if prevLocation.x > currentLocation.x && prevLocation.y > currentLocation.y {
                
                if abs(prevLocation.x - currentLocation.x) < offSet{
                    print("move UP ")
                    return .UP
                }else if abs(prevLocation.y - currentLocation.y) < offSet{
                    print("move left ")
                    return .LEFT
                }else{
                    print("move top _ left")
                    return .UP_LEFT
                }
                
            }else if prevLocation.x > currentLocation.x && prevLocation.y < currentLocation.y {
                
                if abs(prevLocation.x - currentLocation.x) < offSet{
                    print("move down ")
                    return .DOWN
                }else if abs(prevLocation.y - currentLocation.y) < offSet{
                    print("move left ")
                    return .LEFT
                }else{
                    print("move down _ left")
                    return .DOWN_LEFT
                }
                
            }else if prevLocation.x < currentLocation.x && prevLocation.y > currentLocation.y {
                
                if abs(prevLocation.x - currentLocation.x) < offSet{
                    print("move UP ")
                    return .UP
                }else if abs(prevLocation.y - currentLocation.y) < offSet{
                    print("move right ")
                    return .RIGHT
                }else{
                    print("move up _ right")
                    return .UP_RIGHT
                }
                
                
            }else if prevLocation.x < currentLocation.x && prevLocation.y < currentLocation.y {
                
                if abs(prevLocation.x - currentLocation.x) < offSet{
                    print("move down ")
                    return .DOWN
                }else if abs(prevLocation.y - currentLocation.y) < offSet{
                    print("move right ")
                    return .RIGHT
                }else{
                    print("move down _ right")
                    return .DOWN_RIGHT
                }
                
            } else if prevLocation.x == currentLocation.x && prevLocation.y > currentLocation.y {
                print("move up")
                return .UP
            }else if prevLocation.x == currentLocation.x && prevLocation.y < currentLocation.y {
                print("move down")
                return .DOWN
            }else if prevLocation.x < currentLocation.x && prevLocation.y == currentLocation.y {
                print("move right")
                return .RIGHT
            }else if prevLocation.x > currentLocation.x && prevLocation.y == currentLocation.y {
                print("move left")
                return .LEFT
            }
  
        }
        return .NON
    }
    
    
    static func getDirectionBasic(prevLocation:CGPoint,currentLocation:CGPoint) -> Direction{
        
        if abs(prevLocation.x - currentLocation.x) > 10 || abs(prevLocation.y - currentLocation.y) > 10{
            
            if prevLocation.x > currentLocation.x && prevLocation.y > currentLocation.y {
                
                if abs(prevLocation.x - currentLocation.x) < abs(prevLocation.y - currentLocation.y){
                    print("move up")
                    return .UP
                }else{
                    
                    return .LEFT
                }
                
                
            }else if prevLocation.x > currentLocation.x && prevLocation.y < currentLocation.y {
                
                if abs(prevLocation.x - currentLocation.x) < abs(prevLocation.y - currentLocation.y){
                    print("move down")
                    return .DOWN
                }else{
                    print("move left")
                    return .LEFT
                }
                
            }else if prevLocation.x < currentLocation.x && prevLocation.y > currentLocation.y {
                
                if abs(prevLocation.x - currentLocation.x) < abs(prevLocation.y - currentLocation.y){
                    print("move up")
                    return .UP
                }else{
                    print("move right")
                    return .RIGHT
                }
                
            }else if prevLocation.x < currentLocation.x && prevLocation.y < currentLocation.y {
                
                if abs(prevLocation.x - currentLocation.x) < abs(prevLocation.y - currentLocation.y){
                    print("move down")
                    return .DOWN
                }else{
                    print("move right")
                    return .RIGHT
                }
                
            } else if prevLocation.x == currentLocation.x && prevLocation.y > currentLocation.y {
                print("move up")
                return .UP
            }else if prevLocation.x == currentLocation.x && prevLocation.y < currentLocation.y {
                print("move down")
                return .DOWN
            }else if prevLocation.x < currentLocation.x && prevLocation.y == currentLocation.y {
                print("move right")
                return .RIGHT
            }else if prevLocation.x > currentLocation.x && prevLocation.y == currentLocation.y {
                print("move left")
                return .LEFT
            }
            
        }
        return .NON
    }
    
    static func directionToString(direction:Direction)->String?{
        switch direction {
        case .NON :
            return nil
        case .UP :
            if let customValue = UserDefaults.standard.object(forKey: MOVE_UP) as? String {
                return customValue
            }
            return "UP"
            
        case .DOWN :
            if let customValue = UserDefaults.standard.object(forKey: MOVE_DOWN) as? String {
                return customValue
            }
            return "DOWN"
            
        case .LEFT :
            if let customValue = UserDefaults.standard.object(forKey: MOVE_LEFT) as? String {
                return customValue
            }
            return "LEFT"
            
        case .RIGHT :
            if let customValue = UserDefaults.standard.object(forKey: MOVE_RIGHT) as? String {
                return customValue
            }
            return "RIGHT"
            
        case .UP_LEFT :
            if let customValue = UserDefaults.standard.object(forKey: MOVE_UP_LEFT) as? String {
                return customValue
            }
            return "UP_LEFT"
            
        case .UP_RIGHT :
            if let customValue = UserDefaults.standard.object(forKey: MOVE_UP_RIGHT) as? String {
                return customValue
            }
            return "UP_RIGHT"
            
        case .DOWN_RIGHT :
            if let customValue = UserDefaults.standard.object(forKey: MOVE_DOWN_RIGHT) as? String {
                return customValue
            }
            return "DOWN_RIGHT"
            
        case .DOWN_LEFT :
            if let customValue = UserDefaults.standard.object(forKey: MOVE_DOWN_LEFT) as? String {
                return customValue
            }
            return "DOWN_LEFT"
        }
    }
    
    static func getDirectionPeriod(prevLocation:CGPoint,currentLocation:CGPoint) -> Direction{
        
        if prevLocation.x > currentLocation.x && prevLocation.y > currentLocation.y {
            
            if abs(prevLocation.x - currentLocation.x) < abs(prevLocation.y - currentLocation.y){
                print("move up")
                return .UP
            }else{
                return .LEFT
            }
            
        }else if prevLocation.x > currentLocation.x && prevLocation.y < currentLocation.y {
            
            if abs(prevLocation.x - currentLocation.x) < abs(prevLocation.y - currentLocation.y){
                print("move down")
                return .DOWN
            }else{
                print("move left")
                return .LEFT
            }
            
        }else if prevLocation.x < currentLocation.x && prevLocation.y > currentLocation.y {
            
            if abs(prevLocation.x - currentLocation.x) < abs(prevLocation.y - currentLocation.y){
                print("move up")
                return .UP
            }else{
                print("move right")
                return .RIGHT
            }
            
        }else if prevLocation.x < currentLocation.x && prevLocation.y < currentLocation.y {
            
            if abs(prevLocation.x - currentLocation.x) < abs(prevLocation.y - currentLocation.y){
                print("move down")
                return .DOWN
            }else{
                print("move right")
                return .RIGHT
            }
            
        } else if prevLocation.x == currentLocation.x && prevLocation.y > currentLocation.y {
            print("move up")
            return .UP
        }else if prevLocation.x == currentLocation.x && prevLocation.y < currentLocation.y {
            print("move down")
            return .DOWN
        }else if prevLocation.x < currentLocation.x && prevLocation.y == currentLocation.y {
            print("move right")
            return .RIGHT
        }else if prevLocation.x > currentLocation.x && prevLocation.y == currentLocation.y {
            print("move left")
            return .LEFT
        }
        return .NON
    }
    
}
