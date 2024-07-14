//
//  CourseListView.swift
//  NUSTimetable
//
//  Created by Lu Shuyu on 2024/7/14.
//

import SwiftUI

struct CourseListView: View {
    @ObservedObject var viewModel = CourseViewModel()

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchQuery)
                List(viewModel.filteredCourses) { course in
                    NavigationLink(destination: CourseDetailView(course: course, viewModel: viewModel)) {
                        VStack(alignment: .leading) {
                            Text(course.moduleCode)
                                .font(.headline)
                            Text(course.title)
                            HStack {
                                Text("Semesters: \(course.semesters.map { String($0) }.joined(separator: ", "))")
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Courses")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SelectedCoursesView(viewModel: viewModel)) {
                            Text("Selected Courses")
                        }
                    }
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search by Module Code", text: $text)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
        }
    }
}
