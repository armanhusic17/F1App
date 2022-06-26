//
//  FinishingStatus.swift
//  F1App
//
//  Created by Arman Husic on 6/22/22.
//

import Foundation

public struct FinishingStatus: Codable {
    public let data: FinishingStatusData

    private enum CodingKeys: String, CodingKey {
        case data = "MRData"
    }
}

public struct FinishingStatusData: Codable {
    public let series: String
    public let url: String
    public let limit: String
    public let offset: String
    public let total: String
    public let statusTable: StatusTable

    private enum CodingKeys: String, CodingKey {
        case series
        case url
        case limit
        case offset
        case total
        case statusTable = "StatusTable"
    }
}

public struct StatusTable: Codable {
    public let season: String
    public let status: [Status]

    private enum CodingKeys: String, CodingKey {
        case season
        case status = "Status"
    }
}

public struct Status: Codable {
    public let statusID: String
    public let count: String
    public let status: String

    private enum CodingKeys: String, CodingKey {
        case statusID = "statusId"
        case count
        case status
    }
}
