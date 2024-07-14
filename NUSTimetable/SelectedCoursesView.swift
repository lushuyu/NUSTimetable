//
//  SelectedCoursesView.swift
//  NUSTimetable
//
//  Created by Lu Shuyu on 2024/7/14.
//

import SwiftUI

struct SelectedCoursesView: View {
    @ObservedObject var viewModel: CourseViewModel

    var body: some View {
        List {
            ForEach(viewModel.selectedCourses) { course in
                VStack(alignment: .leading) {
                    Text(course.moduleCode)
                        .font(.headline)
                    Text(course.title)
                }
            }
            .onDelete(perform: viewModel.removeCourse)
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Selected Courses")
        .toolbar {
            EditButton()
        }
    }
}
