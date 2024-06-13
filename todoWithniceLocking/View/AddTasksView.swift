//
//  AddTasksView.swift
//  ToDoList-Swift
//
//  Created by رنيم القرني on 07/09/1445 AH.
//

import SwiftUI

struct AddTasksView: View {
    
    @Environment(\.managedObjectContext) var mangedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State var taskTitle: String = ""
    @State var taskDetails: String = ""
    @State var dueDate: Date = Date()
    @State var showingErrorAlert = false // State variable to control the alert
    
    var body: some View {
        VStack {
            List {
                VStack {
                    VStack {
                        Text("Task Title ")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Title", text: $taskTitle)
                            .modifier(TextFieldModifierView())
                            .padding()
                    }
                    VStack {
                        Text("Task Description ")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Description", text: $taskDetails, axis: .vertical)
                            .modifier(TextFieldModifierView())
                            .padding()
                    }
                    
                    DatePicker(selection: $dueDate, in: Date()..., displayedComponents: .date) {
                        Text("Due Date")
                    }
                    Spacer()

                    HStack {
                        Spacer()
                        Button("Add Task") {
                            if !taskTitle.isEmpty {
                                DataController().addTask(name: taskTitle, taskDescription: taskDetails, dueDate: dueDate, context: mangedObjContext)
                                print("Hi")
                                dismiss()
                            } else {
                                showingErrorAlert = true
                            }
                        }.buttonStyle(GrowingButton())
                         

                        Spacer()
                    }
                } .listRowBackground(Color.clear)
                
            }.scrollContentBackground(.hidden)
             .background(Color("backgroundcolor"))
                
        }
        .alert(isPresented: $showingErrorAlert) {
            Alert(title: Text("Error"), message: Text("Task title cannot be empty"), dismissButton: .default(Text("OK")))
        }

    }
}


struct TextFieldModifierView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color("Color"), lineWidth: 3)
            )
    }
}

#Preview {
    AddTasksView()
}
