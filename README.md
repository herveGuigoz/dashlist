# Dashlist

Shopping list application build with ApiPlatform & Flutter

Consume SSE events (using Mercure protocol) to update his state.

## Installation

```bash
make install
```

## How to

### Extract Mercure hub on Response

```js
response.headers.get('Link').match(/<([^>]+)>;\s+rel="[^"]+mercure[^"]*"/)
```

## Todo

- Authentication (doc)[https://symfony.com/doc/current/security/login_link.html]
- User groups
- Item quantity as integer
- Item price