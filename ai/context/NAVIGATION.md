## Router

- Use GoRouter for all navigation
- Routes in routes.dart

## Rules

- NEVER hardcode route strings
- ALWAYS use route constants

## Route Structure

- Define all routes in routes.dart
- Use nested routes for complex flows

## Navigation Types

### Push

context.push(AppRoutes.details);

### Replace

context.go(AppRoutes.home);

## Passing Data
- Use query parameters or extra
context.push(
  AppRoutes.details,
  extra: item,
);


## Error Handling
- Define error screen in router