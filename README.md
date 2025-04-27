📝 TODO List App - Machine Task
A full-featured TODO List Flutter application built as part of a machine task assignment for Rapidd Technologies.

🚀 Features
MVVM Architecture: Clean separation of business logic and UI for better scalability and maintainability.

Provider for State Management: Efficient and organized state handling across the app.

Firebase Integration:

Firestore for real-time database operations.

Authentication for secure user login and task sharing.

Real-Time Task Sharing:

Share tasks with both internal (registered) and external (email-based) users.

Internal shared users can update task status (checkbox) but cannot edit the task title or description.

Responsive UI: Seamless and adaptive experience across mobile, tablet, and web platforms.

Reusable and Scalable Widgets: Designed for easy maintenance and future scaling.

📦 Tech Stack
Flutter: Mobile app development

Dart: Programming language

Firebase:

Firestore (real-time database)

Authentication (email/password)

Provider: For managing application state

✉️ Task Sharing Details
Internal Sharing (Registered Users):

Share tasks internally by entering a registered user's email address.

Both owner and shared user can toggle the checkbox (mark task as completed or pending).

Only the owner can edit the task title and description.

Shared users cannot change the task title or description — they can only update the completion status.

External Sharing (Unregistered Users):

Share tasks with non-registered users via email.

External users receive a view/invite link (custom logic to be handled separately).

📱 Screenshots
<!-- Insert your app screenshots here --> <!-- Example: <img src="screenshots/home_screen.png" width="300"> <img src="screenshots/task_details.png" width="300"> -->
🔧 Getting Started
Clone the repository:

bash
Copy
Edit
git clone https://github.com/shamsheersha/todo_list_machine_task.git
cd todo_list_machine_task
Install dependencies:

bash
Copy
Edit
flutter pub get
Setup Firebase:

Create a new Firebase project.

Enable Firestore Database and Email/Password Authentication.

Add your platform-specific files:

google-services.json for Android (android/app/)

GoogleService-Info.plist for iOS (ios/Runner/)

Run the app:

bash
Copy
Edit
flutter run
🏛 Project Structure (MVVM)
graphql
Copy
Edit
lib/
├── models/         # Data models (TaskModel, UserModel, etc.)
├── views/          # UI screens (HomeView, TaskDetailsView, etc.)
├── view_models/    # Business logic and providers (TaskViewModel, AuthViewModel)
├── services/       # Firebase and API services (FirestoreService, AuthService)
├── widgets/        # Reusable custom widgets (TaskTile, CustomButton, etc.)
├── utils/          # Utility classes and constants
├── main.dart       # App entry point
🔥 Highlights
Clean MVVM Architecture for better scalability.

Real-time synchronization using Firebase Firestore.

Role-based Access:

Owner: Full control (edit title, description, and checkbox).

Shared user: Can only toggle checkbox (cannot edit title/description).

Responsive Design for all screen sizes.

Code Reusability for fast development and easier maintenance.
