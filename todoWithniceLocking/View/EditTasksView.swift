//
//  EditTasksView.swift
//  ToDoList-Swift
//
//  Created by رنيم القرني on 07/09/1445 AH.
//

import SwiftUI

struct EditTasksView: View {
    
    @Environment(\.managedObjectContext) var mangedObjContext
    @Environment(\.dismiss) var dismiss
    
    var task : FetchedResults<Tasks>.Element
    
    @State var taskTitle: String = ""
    @State var taskDetails: String = ""
    @State var dueDate: Date = Date()
    @State var showingErrorAlert = false // State variable to control the alert
    
    var body: some View {
        VStack {
            List{
                VStack{
                    VStack{
                        Text("Task Title ")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Title", text: $taskTitle)
                            .onAppear{
                                taskTitle = task.taskTitle!
                            }
                            .modifier(TextFieldModifierView())
                            .padding()
                    }
                    VStack{
                        Text("Task Descreption ")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Descreption", text: $taskDetails, axis: .vertical)
                            .padding()
                            .onAppear{
                                taskDetails = task.taskDec!
                            }
                            .modifier(TextFieldModifierView())
                            .padding()
                    }
                    
                    DatePicker(selection: $dueDate,in: Date()...,displayedComponents: .date) {
                                   Text("Due Date")
                               }
                    .onAppear{
                        dueDate = task.date!
                    }
                    
                    HStack{
                        Spacer()
                        Button("Edit Task"){
                            if !taskTitle.isEmpty{
                                DataController().editTask(task: task, name: taskTitle, taskDescription: taskDetails, dueDate: dueDate, context: mangedObjContext)
                                dismiss()
                            }else {
                                showingErrorAlert = true // Show the error alert
                            }
                           
                        }.buttonStyle(GrowingButton())
                        Spacer()
                    }
                }.listRowBackground(Color.clear)
            }.scrollContentBackground(.hidden)
             .background(Color("backgroundcolor"))
        }.alert(isPresented: $showingErrorAlert) {
        Alert(title: Text("Error"), message: Text("Task title cannot be empty"), dismissButton: .default(Text("OK")))
            }
     
    }
}


