//
//  CSV.swift
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

import ArgumentParser
import Foundation
import TabularData

struct CSV: AsyncParsableCommand {
    @Option
    var input: String = "leaderboard.json"

    @Option
    var output: String = "leaderboard.csv"

    static var configuration = CommandConfiguration(
        abstract: "Convert leaderboard to CSV"
    )

    mutating func run() async throws {
        let data = try Data(contentsOf: URL(filePath: input))

        let leaderboard = try JSONDecoder().decode(LeaderboardData.self, from: data)

        let members = leaderboard.members.map {
            $0.value
        }.sorted {
            $0.id < $1.id
        }.map {
            $0.dictionaryRepresentation
        }

        let columns: Set<String> = members.map { dict -> [String] in
            Array(dict.keys)
        }.reduce(Set<String>(), { $0.union($1) })

        let initialColumns = ["id", "local_score", "name", "stars"]
        let remainingColumns = Array(columns.subtracting(initialColumns)).sorted()

        let jsonData = try JSONSerialization.data(withJSONObject: members)
        let dataFrame = try DataFrame(jsonData: jsonData, columns: initialColumns + remainingColumns)
        try dataFrame.writeCSV(to: URL(filePath: output))
        print("Wrote \(output)")
    }
}
