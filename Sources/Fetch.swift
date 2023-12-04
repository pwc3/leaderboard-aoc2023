//
//  Fetch.swift
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

struct Fetch: AsyncParsableCommand {
    @Option(help: "leaderboard JSON URL file, containing the URL of the your private leaderboard's JSON")
    var urlFile: String = ".json-url"

    @Option(help: "cookie file, containing the value of the `Cookie` header in your authenticated browser's request")
    var cookieFile: String = ".cookie"

    @Option(help: "output JSON file")
    var output: String = "leaderboard.json"

    static var configuration = CommandConfiguration(
        abstract: "Fetch JSON representation of leaderboard"
    )

    private var cookie: String {
        get throws {
            try String(contentsOf: URL(filePath: cookieFile))
        }
    }

    private var url: URL {
        get throws {
            let urlString = try String(contentsOf: URL(filePath: urlFile))
            guard let url = URL(string: urlString) else {
                throw ErrorMessage("Invalid URL: \(urlString)")
            }
            return url
        }
    }

    mutating func run() async throws {
        var request = try URLRequest(url: url)
        try request.setValue(cookie, forHTTPHeaderField: "Cookie")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard
            let httpResponse = response as? HTTPURLResponse,
            200...299 ~= httpResponse.statusCode
        else {
            throw ErrorMessage("Invalid response")
        }

        try data.write(to: URL(filePath: output))
        print("Wrote \(output)")
    }
}
