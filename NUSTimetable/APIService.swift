//
//  APIService.swift
//  NUSTimetable
//
//  Created by Lu Shuyu on 2024/7/14.
//

import Foundation

class APIService {
    static let shared = APIService()
    let courseListURL = "https://api.nusmods.com/v2/2024-2025/moduleList.json"

    func fetchCourses(completion: @escaping (Result<[Course], Error>) -> Void) {
        guard let url = URL(string: courseListURL) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
                return
            }

            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                completion(.success(courses))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func logInfo(_ message: String) {
        print("INFO: \(message)")
    }

    func fetchCourseDetail(moduleCode: String, completion: @escaping (Result<CourseDetail, Error>) -> Void) {
        let detailURL = "https://api.nusmods.com/v2/2024-2025/modules/\(moduleCode).json"
        logInfo("Fetching course detail from URL: \(detailURL)")
        guard let url = URL(string: detailURL) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("[INFO]: Received JSON: \(jsonString)")
            }
            do {
                let courseDetail = try JSONDecoder().decode(CourseDetail.self, from: data)
                                completion(.success(courseDetail))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
