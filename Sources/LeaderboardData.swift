//
//  LeaderboardData.swift
//  leaderboard-aoc2023
//
//  Copyright (c) 2023 Anodized Software, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

struct LeaderboardData: Codable {
    var owner_id: Int
    var members: [String: Member]
}

struct Member: Codable {
    var stars: Int
    var local_score: Int
    var last_star_ts: Int
    // Maps day (e.g., "1") -> level (i.e., "1" or "2") -> completion
    var completion_day_level: [String: [String: Completion]]?
    var global_score: Int
    var id: Int
    var name: String?

    func getDay(_ day: String) -> [String: Completion]? {
        completion_day_level?[day]
    }

    var days: [String]? {
        guard let keys = completion_day_level?.keys else {
            return nil
        }
        return Array(keys).sorted { (lhs: String, rhs: String) -> Bool in
            lhs.localizedStandardCompare(rhs) == .orderedAscending
        }
    }

    var dictionaryRepresentation: [String : Any] {
        var result: [String : Any] = [
            "id": id,
            "name": name as Any,
            "stars": stars,
            "local_score": local_score,
        ]

        for day in days ?? [] {
            guard let completion = completion_day_level?[day] else {
                continue
            }

            for level in ["1", "2"] {
                // result["d\(day):l\(level) star_index"] = completion[level]?.star_index
                result["d\(day):l\(level) timestamp"] = completion[level]?.get_star_ts
            }
        }

        return result
    }
}

struct Completion: Codable {
    var star_index: Int
    var get_star_ts: Int
}
