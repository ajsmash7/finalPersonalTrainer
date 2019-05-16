//
//  WeightRecordDelegate.swift
//  iOSPersonalTrainer
//
//  Created by AJMac on 5/7/19.
//  Copyright © 2019 AJMac. All rights reserved.
//

import Foundation

@objc protocol WeightRecordDelegate {
    @objc optional func newWeightRecord(client: Client, weight: Float, date: Date, bmi: Float, photo: URL) -> Void
    @objc optional func modify(weightRecord:WeightRecord) -> Void
    @objc optional func delete(weightRecord:WeightRecord) -> Void
    
}
