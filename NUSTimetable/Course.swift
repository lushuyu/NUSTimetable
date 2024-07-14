//
//  Course.swift
//  NUSTimetable
//
//  Created by Lu Shuyu on 2024/7/14.
//

import Foundation

struct Course: Decodable, Identifiable {
    let id = UUID()
    let moduleCode: String
    let title: String
    let semesters: [Int]
}

struct CourseDetail: Decodable {
    let moduleCode: String
    let title: String
    let description: String
    let department: String
    let faculty: String
    let workload: [Int]
    let semesterData: [SemesterData]
}

struct SemesterData: Decodable {
    let semester: Int
    let timetable: [Timetable]
}

struct Timetable: Decodable {
    let classNo: String
    let startTime: String
    let endTime: String
    let weeks: [Int]
    let venue: String
    let day: String
    let lessonType: String
    let size: Int
    let covidZone: String

    enum CodingKeys: String, CodingKey {
        case classNo, startTime, endTime, weeks, venue, day, lessonType, size, covidZone
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        classNo = try container.decode(String.self, forKey: .classNo)
        startTime = try container.decode(String.self, forKey: .startTime)
        endTime = try container.decode(String.self, forKey: .endTime)
        venue = try container.decode(String.self, forKey: .venue)
        day = try container.decode(String.self, forKey: .day)
        lessonType = try container.decode(String.self, forKey: .lessonType)
        size = try container.decode(Int.self, forKey: .size)
        covidZone = try container.decode(String.self, forKey: .covidZone)

        do {
            weeks = try container.decode([Int].self, forKey: .weeks)
        } catch {
            // 解码失败，处理字典情况
            let dictValue = try container.decode([String: Int].self, forKey: .weeks)
            weeks = dictValue.values.map { $0 }
        }
    }
}
