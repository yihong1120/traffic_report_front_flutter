# Traffic-Report-Front-Flutter

## Overview
'Traffic-Report-Front-Flutter' serves as the frontend counterpart of the 'Traffic-Violation-Report-System', a digital platform dedicated to enhancing transparency in traffic law enforcement across Taiwan. Utilising Flutter, this web application allows users to interact seamlessly with the backend system to report traffic violations and view responses from law enforcement agencies.

## Features
- **User-Friendly Interface:** Developed with Flutter for a responsive and intuitive user experience.
- **Violation Reporting:** Enables users to report traffic violations easily.
- **Response Display:** Showcases responses from authorities to reported violations.
- **Integration with Backend:** Seamlessly connects with the Django-based backend system.

## Directory Structure
```lib/
  |- components/    # Shared components, such as custom buttons, form inputs, etc.
  |- models/        # Data models
  |- screens/       # Different screens/pages
  |- services/      # Services, like network requests, local storage
  |- utils/         # Utility classes, such as utility functions, constant definitions
 main.dart         # Entry file```

## Overview
'Traffic-Report-Front-Flutter' serves as the frontend counterpart of the 'Traffic-Violation-Report-System', a digital platform dedicated to enhancing transparency in traffic law enforcement across Taiwan. Utilising Flutter, this web application allows users to interact seamlessly with the backend system to report traffic violations and view responses from law enforcement agencies.

## Features
- **User-Friendly Interface:** Developed with Flutter for a responsive and intuitive user experience.
- **Violation Reporting:** Enables users to report traffic violations easily.
- **Response Display:** Showcases responses from authorities to reported violations.
- **Integration with Backend:** Seamlessly connects with the Django-based backend system.

## Directory Structure
```
lib/
  |- components/    # Shared components, such as custom buttons, form inputs, etc.
      |- media_picker.dart
      |- media_preview.dart
      |- navigation_drawer.dart
      |- report_form.dart
  |- models/        # Data models
      |- social_account.dart
      |- traffic_violation.dart
  |- screens/       # Different screens/pages
      |- accounts/  # Screens related to account, like login, registration, user profile
          |- routes.dart
          |- login.dart
          |- register.dart
          |- profile.dart
      |- reports/   # Screens related to reports, such as creating a report, viewing report list
          |- routes.dart
          |- report_list.dart
          |- report_detail.dart
          |- create_report.dart
      |- chat/   # Screens related to chatbot, you can chat with gemini
          |- routes.dart
          |- chat_page.dart
      |- map/       # Map display, such as showing the map on the homepage
          |- routes.dart
          |- home_map.dart
  |- services/      # Services, like network requests, local storage
      |- auth_service.dart
      |- report_service.dart
      |- social_service.dart
  |- utils/         # Utility classes, such as utility functions, constant definitions
  main.dart         # Entry file
```

## Development Roadmap
- [x] Initial project setup and configuration
- [x] Implement user authentication and authorisation
- [x] Develop the report submission form
- [x] Create a dashboard for displaying violation reports
- [ ] Integrate with the backend API for data retrieval and submission
- [ ] Implement responsive design for mobile and tablet views
- [ ] Test functionalities across different browsers and devices
- [ ] Optimize performance and loading times
- [ ] Implement user feedback and rating system
- [ ] Prepare for production deployment

## Getting Started
To run the project locally:

1. Ensure you have Flutter installed on your system. Visit [Flutter Installation Guide](https://flutter.dev/docs/get-started/install) for instructions.
2. Clone the repository:
   ```
   git clone https://github.com/your-username/Traffic-Report-Flutter-Web.git
   ```
3. Navigate to the project directory:
   ```
   cd Traffic-Report-Flutter-Web
   ```
4. Run the application:
   ```
   flutter run -d chrome
   ```

## Contributing
We welcome contributions! Please read our [Contributing Guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests., and the process for submitting pull requests.

## License
This project is licensed under the [AGPL-3.0 License](LICENSE) - see the LICENSE file for details.

## Acknowledgements
- [YOLOv8-License-Plate-Insights](https://github.com/yihong1120/YOLOv8-License-Plate-Insights) for license plate recognition.
- All contributors and community members.
