# Authentication Flow

← [Back to CLAUDE.md](../../CLAUDE.md)

## Overview

The app implements a WebView-based authentication system that supports both direct login and OAuth providers.

**Implementation:** `lib/presentation/widget/auth/login_webview.dart`

## Authentication Methods

### 1. Direct Form Login

User logs in via Habr's login form.

**URL:** `${Urls.siteApiUrl}/v1/auth/habrahabr/?back=/ru/all`

**Flow:**
1. User enters credentials
2. Submits login form
3. Habr redirects to `/ru/all`
4. App extracts cookies and processes authentication

### 2. OAuth Providers

Third-party authentication via OAuth providers.

**Supported Providers:**
- GitHub
- Google
- VK (VKontakte)
- Yandex
- X (Twitter)

**Flow:**
1. User clicks OAuth provider button
2. Redirects to provider's authentication page
3. User authenticates with provider
4. Provider redirects back to Habr with authorization code
5. App processes the authentication

## Login Flow Logic

The `LoginWebView` widget uses `WebViewController` with `NavigationDelegate` to intercept URLs and handle authentication.

### URL Interception Strategy

#### Direct Login Flow

**Pattern:** `/ru/all` (no parameters)

**Behavior:**
1. Extract cookies via `WebviewCookieManager`
2. Save cookies to `TokenRepository.cookieJar`
3. Extract `sid` token from cookies
4. Pass token to `LoginCubit.handle()`
5. Close WebView on success

**Code Flow:**
```dart
if (url.path == '/ru/all' && url.queryParameters.isEmpty) {
  // Direct login complete
  await extractAndSaveCookies();
  final token = extractSidToken();
  loginCubit.handle(token);
}
```

#### OAuth Intermediate Redirect

**Pattern:** `/ru/all?code=X` (code only, no state)

**Behavior:**
1. Allow navigation to continue
2. DO NOT process cookies yet
3. Wait for OAuth flow to complete

**Why?**
This is an intermediate step in the OAuth flow. The provider hasn't finished authentication yet.

**Code Flow:**
```dart
if (url.path == '/ru/all' &&
    url.queryParameters.containsKey('code') &&
    !url.queryParameters.containsKey('state')) {
  // Let navigation continue
  return NavigationDecision.navigate;
}
```

#### OAuth Complete

**Pattern:** `/ru/all?code=X&state=Y` (both code and state)

**Behavior:**
1. Both `code` and `state` parameters present
2. Extract cookies via `WebviewCookieManager`
3. Save cookies to `TokenRepository.cookieJar`
4. Extract `sid` token
5. Pass token to `LoginCubit.handle()`
6. Close WebView on success

**Code Flow:**
```dart
if (url.path == '/ru/all' &&
    url.queryParameters.containsKey('code') &&
    url.queryParameters.containsKey('state')) {
  // OAuth complete
  await extractAndSaveCookies();
  final token = extractSidToken();
  loginCubit.handle(token);
}
```

## Security

### Domain Whitelisting

Navigation is restricted to whitelisted domains via `_allowedOAuthDomains` constant.

**Always Allowed:**
- `habr.com`
- `account.habr.com`

**OAuth Provider Domains:**
- `github.com` - GitHub OAuth
- `accounts.google.com` - Google OAuth
- `oauth.vk.com` - VK OAuth
- `passport.yandex.ru` - Yandex OAuth
- `api.twitter.com` - X (Twitter) OAuth

**Implementation:**
```dart
NavigationDecision _navigationDelegate(NavigationRequest request) {
  final uri = Uri.parse(request.url);

  if (_isAllowedDomain(uri.host)) {
    return NavigationDecision.navigate;
  }

  return NavigationDecision.prevent;
}
```

### Cookie Security

**Cookie Storage:**
- Cookies saved to both `Urls.baseUrl` and `Urls.mobileBaseUrl`
- Ensures API compatibility across different endpoints

**Token Extraction:**
- Extracts `sid` (session ID) token from cookies
- Securely stored via `TokenRepository`

## State Management

### LoginCubit

Manages authentication state using `LoadingStatus` enum.

**States:**
- `initial` - No authentication attempt
- `loading` - Authentication in progress
- `success` - Authentication successful
- `failure` - Authentication failed

**Methods:**
- `handle(String token)` - Process authentication token
- `reset()` - Reset to initial state

### UI Integration

**BlocListener:**
UI reacts to state changes via `BlocListener`.

```dart
BlocListener<LoginCubit, LoginState>(
  listener: (context, state) {
    if (state.status == LoadingStatus.success) {
      Navigator.pop(context); // Close WebView
    } else if (state.status == LoadingStatus.failure) {
      showError(state.error);
    }
  },
  child: LoginWebView(),
)
```

### Navigation

**Success:**
- `Navigator.pop()` closes the WebView
- User returns to previous screen
- `GlobalBlocListener` triggers profile fetch

**Failure:**
- Show error message
- Allow user to retry
- WebView remains open

## Implementation Details

### WebViewController Setup

```dart
final controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setNavigationDelegate(
    NavigationDelegate(
      onNavigationRequest: _handleNavigation,
      onPageFinished: _handlePageFinished,
    ),
  )
  ..loadRequest(Uri.parse(loginUrl));
```

### Cookie Extraction

```dart
final cookieManager = WebviewCookieManager();
final cookies = await cookieManager.getCookies(url);

// Save to both base URLs
await tokenRepository.saveCookies(Urls.baseUrl, cookies);
await tokenRepository.saveCookies(Urls.mobileBaseUrl, cookies);

// Extract sid token
final sidToken = cookies.firstWhere(
  (c) => c.name == 'sid',
  orElse: () => throw Exception('No sid token found'),
).value;
```

## Common Issues & Solutions

### Issue: OAuth Login Not Working

**Symptom:** OAuth redirects but doesn't complete login

**Solution:** Check that both `code` and `state` parameters are present before processing

### Issue: Cookies Not Saved

**Symptom:** Login appears successful but user is not authenticated

**Solution:** Ensure cookies are saved to both `baseUrl` and `mobileBaseUrl`

### Issue: Domain Blocked

**Symptom:** Navigation prevented during OAuth flow

**Solution:** Add domain to `_allowedOAuthDomains` whitelist

## Testing Authentication

### Manual Testing

1. **Direct Login:**
   - Open app → Login screen
   - Enter credentials
   - Submit form
   - Verify cookies saved and user authenticated

2. **OAuth Login:**
   - Open app → Login screen
   - Click OAuth provider (e.g., GitHub)
   - Authenticate with provider
   - Verify redirect back to app
   - Verify cookies saved and user authenticated

### Debug Logging

Enable logging to track authentication flow:
```dart
logger.info('Navigation to: ${request.url}', title: 'Auth');
logger.info('Query params: ${uri.queryParameters}', title: 'Auth');
logger.info('Cookies extracted: ${cookies.length}', title: 'Auth');
logger.info('Token: $sidToken', title: 'Auth');
```

## Related Documentation

- [App Initialization Flow](app-initialization.md) - Bootstrap and BLoC initialization
- [Presentation Layer](../architecture/presentation-layer.md) - Global BLoC coordination
- [Code Style](../development/code-style.md) - BLoC conventions

---

← [Back to CLAUDE.md](../../CLAUDE.md)
