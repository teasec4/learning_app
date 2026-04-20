## Architecture Requirements
- Project follows Clean Architecture

## State Management
- All API via AppServices
- Use GoRoute for routing
- Use Provider as a DI and State Managment
- Avoid setState for business logic
- Separate UI state and business state

## API Access
- NEVER call APIs directly from UI
- ALWAYS go through AppServices
- Services must be injected, not created manually

## Async Safety
- ALWAYS check mounted before using context after await

## UI Structure

- Keep widgets small and composable
- Extract reusable parts into separate widgets
- Use const constructors where possible

## Performance

- Avoid unnecessary rebuilds
- Use const widgets
- Use selectors when possible

## Naming Conventions

- Providers: xxxProvider
- Services: XxxService
- Screens: XxxScreen
- Widgets: XxxWidget