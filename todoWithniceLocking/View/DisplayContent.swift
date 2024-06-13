//
//  DisplayContent.swift
//  ToDoList-Swift
//
//  Created by رنيم القرني on 25/09/1445 AH.
//

import SwiftUI

struct DisplayContent: View {
    @Environment(\.managedObjectContext) var mangedObjContext
    @Environment(\.dismiss) var dismiss
    var task : FetchedResults<Tasks>.Element
    @State private var refreshID = UUID()
    @State var showingEditView: Bool = false
    var body: some View {
            List {
                VStack{
                    ZStack {
                        VStack {
                            HStack {
                                Text("Task Details")
                                    .font(.title3.bold())
                                Spacer()
                            }
                            .padding()
                            Spacer()
                            Text("\(task.taskDec ?? " ")")
                                .font(.title3.bold())
                                .padding()
                            Spacer()
                            
                            Text("completed Date: \((task.date ?? Date()).formatted(.dateTime.day().month().year()))")
                                .padding()
                        }
                    }
                    .listRowBackground(Color.clear)
                    .foregroundStyle(.white)
                    .frame(width: 360, height: 400)
                    .background {
                        LinearGradient(colors: [Color("Color")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                    Spacer()
                Button(action: {
                    showingEditView.toggle()
                }, label: {
                   Text("Edit")
                    .frame(minWidth: 0, maxWidth: 190)
                        
                })
                .buttonStyle(GrowingButton())
                .sheet(isPresented: $showingEditView) {
                    EditTasksView(task:task)
                }
                .id(refreshID)
                    .onAppear {
                        self.refreshID = UUID()
                    }
                
                }.listRowBackground(Color.clear)

                
            }
            .listStyle(.plain)
            .background(Color("backgroundcolor"))
            .navigationTitle("\(task.taskTitle ?? " ")")

    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color("Color"))
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
