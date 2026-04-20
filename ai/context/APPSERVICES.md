## Overview

AppServices is the central dependency container for all services.


## Rules

- NEVER instantiate services manually
- ALWAYS access via appServices
- Services should be stateless or properly managed

## Example

final user = await appServices.userService.getCurrentUser();

## Cleanup

- Dispose services if required
- Close streams
- Cancel subscriptions