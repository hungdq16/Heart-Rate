//
//  FirebaseRemoteConfigService.swift
//  Heart Rate
//
//  Created by Hùng Đặng on 11/04/2024.
//

import Foundation
import FirebaseRemoteConfig

struct FirebaseRemoteConfigService {
    
    private let remoteConfig: RemoteConfig

    public static let shared = FirebaseRemoteConfigService()

    private init() {
        self.remoteConfig = RemoteConfig.remoteConfig()

        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600
        settings.fetchTimeout = 180

        remoteConfig.configSettings = settings
    }

    public func initialize() async throws {
        try await remoteConfig.fetchAndActivate()
    }

    public func getBool(config: String) -> Bool {
        return remoteConfig.configValue(forKey: config).boolValue
    }

    public func getString(config: String) -> String? {
        return remoteConfig.configValue(forKey: config).stringValue
    }

    public func getInt(config: String) -> Int {
        return Int(truncating: remoteConfig.configValue(forKey: config).numberValue)
    }

    public func getJson<T: Decodable>(config: String) -> T? {
        do {
            let dataResponse = remoteConfig.configValue(forKey: config).dataValue
            let encoder = JSONDecoder()
            let response = try encoder.decode(T.self, from: dataResponse)
            return response
        } catch let error {
            print("Error fetching JSON data from remote config: \(error)")
            return nil
        }
    }
}
