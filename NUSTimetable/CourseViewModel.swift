//
//  CourseViewModel.swift
//  NUSTimetable
//
//  Created by Lu Shuyu on 2024/7/14.
//

import Foundation
import SwiftUI

class CourseViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var searchQuery = ""
    @Published var selectedCourses: [Course] = []

    init() {
        fetchCourses()
    }

    func fetchCourses() {
        APIService.shared.fetchCourses { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let courses):
                    self.courses = courses
                case .failure(let error):
                    print("Error fetching courses: \(error)")
                }
            }
        }
    }

    var filteredCourses: [Course] {
        if searchQuery.isEmpty {
            return courses
        } else {
            return courses.filter { $0.moduleCode.contains(searchQuery) }
        }
    }

    func selectCourse(_ course: Course) {
        if !selectedCourses.contains(where: { $0.id == course.id }) {
            selectedCourses.append(course)
        }
    }

    func removeCourse(at indexSet: IndexSet) {
        selectedCourses.remove(atOffsets: indexSet)
    }
}
