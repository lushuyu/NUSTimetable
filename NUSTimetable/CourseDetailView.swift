//
//  CourseDetailView.swift
//  NUSTimetable
//
//  Created by Lu Shuyu on 2024/7/14.
//

import SwiftUI

struct CourseDetailView: View {
    let course: Course
    @ObservedObject var viewModel: CourseViewModel
    @State private var courseDetail: CourseDetail?
    @State private var selectedSemester: Int?

    var body: some View {
        VStack {
            if let detail = courseDetail {
                Text(detail.title)
                    .font(.largeTitle)
                    .padding()

                Text(detail.description)
                    .padding()

                Text("Department: \(detail.department)")
                Text("Faculty: \(detail.faculty)")
                Text("Workload: \(detail.workload.map { String($0) }.joined(separator: ", "))")

                if detail.semesterData.count > 1 {
                    Picker("Select Semester", selection: $selectedSemester) {
                        ForEach(detail.semesterData, id: \.semester) { semesterData in
                            Text("Semester \(semesterData.semester)").tag(semesterData.semester as Int?)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                } else if let firstSemester = detail.semesterData.first {
                    Text("Semester \(firstSemester.semester)")
                        .padding()
                    // 在 onAppear 中设置 selectedSemester
                }

                Button(action: {
                    if let semester = selectedSemester {
                        viewModel.selectCourse(course)
                    }
                }) {
                    Text("Select Course")
                }
                .disabled(selectedSemester == nil)
                .padding()
            } else {
                ProgressView("Loading...")
                    .onAppear {
                        fetchCourseDetail()
                    }
            }
        }
        .navigationTitle(course.moduleCode)
        .onAppear {
            if let firstSemester = courseDetail?.semesterData.first, courseDetail?.semesterData.count == 1 {
                DispatchQueue.main.async {
                    self.selectedSemester = firstSemester.semester
                }
            }
        }
    }

    func fetchCourseDetail() {
        APIService.shared.fetchCourseDetail(moduleCode: course.moduleCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self.courseDetail = detail
                    if let firstSemester = detail.semesterData.first, detail.semesterData.count == 1 {
                        self.selectedSemester = firstSemester.semester
                    }
                case .failure(let error):
                    print("Error fetching course detail: \(error)")
                }
            }
        }
    }
}
