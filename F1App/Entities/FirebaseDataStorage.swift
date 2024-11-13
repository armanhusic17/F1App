//
//  FirebaseDataStorage.swift
//  F1App
//
//  Created by Arman Husic on 12/2/23.
//

import Foundation
import FirebaseStorage
import UIKit

class FirebaseDataStorage {
    private let storage = Storage.storage()

    func getDataFromFirebase(fromPath path: String, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        let storgaeRef = storage.reference()
        let dataRef = storgaeRef.child(path)
        
        dataRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                
                completion(.failure(error))
            } else if let data = data {
                // Successfully gathered data
                completion(.success(data))
            }
        }
    }
}
