//
//  AuthModelDelegate.swift
//  F1App
//
//  Created by Arman Husic on 4/27/24.
//
import UIKit

protocol AuthModelDelegate: NSObject {
    func didCompleteSignIn(_ viewController: UIViewController)
}
