//
//  FirebaseDataStorage.swift
//  F1App
//
//  Created by Arman Husic on 12/2/23.
//

import Foundation
import FirebaseStorage

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
    
    
    func getImag(coreData: CoreDataHelper,img: String){
        self.getDataFromFirebase(fromPath: img) { result in
            switch result {
            case .success(let data):
                // Handle the successful retrieval of data
                // For example, if this is image data, you can convert it to UIImage
                guard let image = UIImage(data: data) else {return}
                DispatchQueue.main.async {
                    // Update your UI on the main thread
                    print(image)
                    coreData.saveImage(image: image) { Success, Error in
                        if Success {
                            print("SUCCESSFULLY SAVED IMAGE FROM FIREBASE")
                        }
                    }
                }
            case .failure(let error):
                // Handle any errors
                print("Error fetching data: \(error.localizedDescription)")
                // You may also want to show an alert or some error message to the user
            }
        }
    }
    
    
    
    
}
