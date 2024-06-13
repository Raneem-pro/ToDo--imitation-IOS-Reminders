import SwiftUI

struct ContentView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .forward)]) var tasks: FetchedResults<Tasks>
    @State var searchTaskName = ""
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State var taskState : taskCase = .today
    @State private var showingAddView: Bool = false
    @State private var isMoving: Bool = false
    @State private var scheduleTasksCount: Int = 0
    @State private var tasksCountForToday: Int = 0
    
    var body: some View {
        NavigationView{
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    NavigationLink {
                        ShowTasksView(taskState: $taskState, title: "Today")
                            .onAppear{
                                taskState = .today
                            }
                    } label: {
                        VStack {
                            HStack{
                                Spacer()
                                Text("\(Date().formatted(.dateTime.day().month()))")
                            }
                            Spacer()
                            HStack {
                                Text("Today")
                                Spacer()
                                Text("\(tasksCountForToday)")
                                    .onAppear {
                                        (tasksCountForToday, scheduleTasksCount) = fetchTasksCountForTodayAndScheduled()
                                    }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .accentColor(.white)
                        .background(Color("Color"))
                        .clipShape(RoundedRectangle(cornerRadius: 14.0, style: .continuous))
                    }
                    NavigationLink {
                        ShowTasksView(taskState: $taskState, title: "schedule")
                            .onAppear{
                                taskState = .scheduled
                            }
                        
                    } label: {
                        VStack {
                            HStack{
                                Spacer()
                                Image(systemName: "calendar.circle")
                                    .font(.system(size: 20.0))
                            }
                            Spacer()
                            HStack {
                                Text("schedule")
                                Spacer()
                                Text("\(scheduleTasksCount)")
                                    .onAppear {
                                        (tasksCountForToday, scheduleTasksCount) = fetchTasksCountForTodayAndScheduled()
                                    }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .accentColor(.white)
                        .background(Color("Color"))
                        .clipShape(RoundedRectangle(cornerRadius: 14.0, style: .continuous))
                    }
                    
                }.padding()
                
                NavigationLink {
                    ShowTasksView(taskState: $taskState, title: "Done")
                        .onAppear{
                            taskState = .Done
                        }
                    
                } label: {
                    VStack {
                        HStack{
                            Spacer()
                            Image(systemName: "tray")
                        }
                        Spacer()
                        HStack {
                            Text("Done")
                            Spacer()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .accentColor(.white)
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 14.0, style: .continuous))
                }.padding()
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            Button(action: {
                                showingAddView.toggle()
                            }) {
                                Label("Add Task", systemImage: "plus.circle")
                            }
                        }
                    }
                    .sheet(isPresented: $showingAddView) {
                        AddTasksView()
                            .onDisappear{
                                (tasksCountForToday, scheduleTasksCount) = fetchTasksCountForTodayAndScheduled()
                            }
                    }
                .searchable(text: $searchTaskName)
                .background(Color("backgroundcolor"))
            }
            .navigationTitle("To Do")
            .background(Color("backgroundcolor"))
        }
    }
    
    func fetchTasksCountForTodayAndScheduled() -> (Int, Int) {
        let today = Date()
        let calendar = Calendar.current
        var tasksCountForToday = 0
        var scheduleTasksCount = 0
        for task in tasks {
            if !task.isDone{
                if let dueDate = task.date {
                    if calendar.isDate(dueDate, inSameDayAs: today) {
                        tasksCountForToday += 1
                    } else if dueDate > today{
                            scheduleTasksCount += 1
                    }
                }
            }
        }
        
        return (tasksCountForToday, scheduleTasksCount)
    }
}
    
enum taskCase{
    case today
    case Done
    case scheduled
}

#Preview {
    ContentView()
}

