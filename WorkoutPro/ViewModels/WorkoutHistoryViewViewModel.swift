import Foundation


class WorkoutHistoryViewViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var isEditingWorkouts: Bool = false
    @Published var viewedWorkout: Workout = Workout()
    @Published var viewedWorkoutViewModel: WorkoutViewViewModel = WorkoutViewViewModel()
    @Published var activeFullScreenCover: ActiveFullScreenCover?
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var years: [Int] = []
    
    enum ActiveFullScreenCover: Identifiable {
        case workout
        case routineSelector
        
        
        var id: Int {
            hashValue
        }
    }
    
    static var shared = WorkoutHistoryViewViewModel()
    
    private init() {
        fetchWorkouts()
        setupYears()
    }
    
    private func setupYears() {
        let mostPastYear = getMostPastYear()
        let currentYear = getCurrentYear()
        self.years = Array(mostPastYear...currentYear).reversed()
    }
    
    private func getMostPastYear() -> Int {
        return DatabaseManager.shared.getMostPastDate()
    }
    
    private func getCurrentYear() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: Date())
        return components.year!
    }
    
    func filterWorkouts(year: Int, month: Int) -> [Workout] {
        let calendar = Calendar.current
        let filteredWorkouts = workouts.filter { workout in
            let components = calendar.dateComponents([.year, .month], from: workout.startTime)
            return components.year == year && components.month == month
        }
        for workout in filteredWorkouts.sorted(by: { $0.startTime > $1.startTime }) {
            print(workout.name)
        }
        return filteredWorkouts.sorted { $0.startTime > $1.startTime }
    }
    
    func formatDuration(minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        var formattedString = ""
        if hours > 0 {
            formattedString += "\(hours)hr "
        }
        if remainingMinutes > 0 {
            formattedString += "\(remainingMinutes)min"
        }
        return formattedString.trimmingCharacters(in: .whitespaces)
    }
    
    func fetchWorkouts() {
        workouts = DatabaseManager.shared.fetchWorkouts()
        setupYears() // Ensure years are updated based on new workouts
    }
    
    func deleteWorkout(workoutID: String) {
        if let workoutToDelete = workouts.first(where: { $0.id == workoutID }) {
            let _ = DatabaseManager.shared.deleteWorkout(workout: workoutToDelete)
            self.fetchWorkouts()
        }
    }
    
    func setViewedWorkout() {
        self.viewedWorkout = Workout()
        self.viewedWorkoutViewModel = WorkoutViewViewModel()
        self.activeFullScreenCover = .workout
    }
    
    func setOldViewedWorkout(workout: Workout) {
        self.viewedWorkout = workout.copy() as? Workout ?? Workout()
        self.viewedWorkoutViewModel = WorkoutViewViewModel(originalWorkout: workout.copy() as? Workout)
        self.activeFullScreenCover = .workout
    }
    
    func setRoutineViewedWorkout(workout: SavedWorkout) {
        self.viewedWorkout = Workout(name: workout.name, movements: workout.movements)
        self.viewedWorkoutViewModel = WorkoutViewViewModel()
        self.activeFullScreenCover = .workout
    }
}
