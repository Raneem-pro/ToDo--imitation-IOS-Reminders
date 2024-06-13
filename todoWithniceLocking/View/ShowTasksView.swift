import SwiftUI

struct ShowTasksView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .forward)]) var tasks: FetchedResults<Tasks>
    @Binding var taskState: taskCase
    @State private var sortingCriteria: SortingCriteria = .dueDate
    var title: String

    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(sortedTasks) { task in
                    VStack {
                        displayTasks(for: task)
                    }.listRowBackground(Color.clear)
                    
                }
                .onDelete(perform: deleteTask)
            }.listStyle(.plain)
        }
        .navigationTitle("\(title) Tasks")
        .background(Color("backgroundcolor"))
    }

    var sortedTasks: [Tasks] {
        switch taskState {
           case .today:
               return tasks.filter { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: Date()) && !$0.isDone }
           case .scheduled:
                return tasks.filter{ $0.date ?? Date() > Date() && !$0.isDone }
           case .Done:
                return tasks.filter { $0.isDone }
        }
    }



    func deleteTask(offsets: IndexSet) {
        withAnimation(.spring){
            offsets.map { tasks[$0] }.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }

    func displayTasks(for task: Tasks) -> some View {
        NavigationLink(destination: DisplayContent(task: task)) {
            HStack {
                Button(action: {
                    withAnimation(.bouncy){
                        task.isDone.toggle()
                        DataController().save(context: managedObjContext)
                    }
                }, label: {
                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isDone ? .gray : .blue)
                })
                .buttonStyle(BorderlessButtonStyle())
                VStack(alignment: .leading) {
                    Text(task.taskTitle ?? "Untitled Task")
                        .foregroundStyle(title == "Done" ? .gray : .black)
                    Text("\((task.date ?? Date()).formatted(.dateTime.day().month().year()))")
                        .font(.caption)
                        .foregroundColor(Calendar.current.component(.day, from: Date()) > Calendar.current.component(.day, from: task.date ?? Date()) && !task.isDone ? .red : .black)



                }
            }
        }
    }
    
}

enum SortingCriteria {
    case dueDate
    case isCompleted
    case newestTask
}

struct ShowTasksView_Previews: PreviewProvider {
    static var previews: some View {
        ShowTasksView(taskState: .constant(.Done), title: "")
    }
}
