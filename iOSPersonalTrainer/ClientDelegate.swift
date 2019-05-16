//
//  ClientDelegate.swift
//  iOSPersonalTrainer
//
//  Created by AJMac on 5/7/19.
//  Copyright © 2019 AJMac. All rights reserved.
//

import Foundation

@objc protocol ClientDelegate {
    @objc optional func newClient(name:String, age:Int16, initialWeight:Float, height:Float) -> Void
    
    @objc optional func modify(client:Client) -> Void
    @objc optional func delete(client:Client) -> Void
    @objc optional func setClient(client:Client) -> Void
    @objc optional func getClient() -> Client
    
}
