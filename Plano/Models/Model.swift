////
////  Model.swift
////  Plano
////
////  Created by Rayhan Martiza Faluda on 09/04/20.
////  Copyright © 2020 Mini Challenge 1 - Group 7. All rights reserved.
////
//
//import Foundation
//import CloudKit
//
//class Model {
//  // MARK: - iCloud Info
//  let container: CKContainer
//  let publicDB: CKDatabase
//  let privateDB: CKDatabase
//
//  // MARK: - Properties
//  private(set) var establishments: [Establishment] = []
//  static var currentModel = Model()
//
//  init() {
//    container = CKContainer.default()
//    publicDB = container.publicCloudDatabase
//    privateDB = container.privateCloudDatabase
//  }
//
//  @objc func refresh(_ completion: @escaping (Error?) -> Void) {
//    let predicate = NSPredicate(value: true)
//    let query = CKQuery(recordType: "Establishment", predicate: predicate)
//    establishments(forQuery: query, completion)
//  }
//
//
//  private func establishments(forQuery query: CKQuery, _ completion: @escaping (Error?) -> Void) {
//    publicDB.perform(query, inZoneWith: CKRecordZone.default().zoneID) { [weak self] results, error in
//      guard let self = self else { return }
//      if let error = error {
//        DispatchQueue.main.async {
//          completion(error)
//        }
//        return
//      }
//      guard let results = results else { return }
//      self.establishments = results.compactMap {
//        Establishment(record: $0, database: self.publicDB)
//      }
//      DispatchQueue.main.async {
//        completion(nil)
//      }
//    }
//  }
//}
