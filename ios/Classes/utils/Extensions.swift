//
//  Extensions.swift
//  voip24h_sdk_mobile
//
//  Created by Phát Nguyễn on 15/08/2022.
//

import Foundation

func toJson(from object: Any?) -> String? {
    if(object == nil) {
        return nil
    }
    guard let data = try? JSONSerialization.data(withJSONObject: object!, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}

extension Decodable {
    static func toObject(JSONString: String) -> Self? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Self.self, from: Data(JSONString.utf8))
        } catch let error {
            print(error)
            return nil
        }
    }
}
