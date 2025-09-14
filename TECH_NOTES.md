# TECH_NOTES.md

## Architecture Overview

### State Management

**Choice: Provider Pattern**

- **Why**: Lightweight, officially recommended, easy to test and debug
- **Trade-offs**: Less powerful than Bloc/Riverpod but sufficient for this scope
- **Implementation**: Single `BusinessProvider` managing app state with proper separation of concerns

### Networking Layer

**Choice: Dio + Repository Pattern**

- **Why**: Dio provides excellent error handling, interceptors, and request/response transformation
- **Trade-offs**: Overkill for local JSON but ensures easy API migration later
- **Implementation**: `ApiService` abstracts network calls, `BusinessRepository` manages data flow

### Data Layer Architecture

```
UI Layer (Widgets)
    ↓
Provider (State Management)
    ↓
Repository (Data Coordination)
    ↓
Services (API + Local Storage)
```

### Component Design

**Reusable Card System:**

- `BaseCard<T>` - Generic abstract base class
- `BusinessCard` - Concrete implementation for Business model
- `ServiceCard` - Future implementation for Service model
- **Trade-off**: Slight complexity increase for future flexibility

## Key Architectural Decisions

### 1. Data Normalization Strategy

**Problem**: Messy JSON keys (`biz_name`, `bss_location`, `contct_no`)
**Solution**: Factory constructor with validation and normalization

```dart
factory Business.fromJson(Map<String, dynamic> json) {
  return Business(
    name: _validateBusinessName(json['biz_name']),
    location: _validateLocation(json['bss_location']),
    contactNumber: _normalizePhoneNumber(json['contct_no']),
  );
}
```

### 2. Offline-First Strategy

**Implementation**: Cache-first with background refresh

1. Load from cache immediately (if available)
2. Fetch fresh data in background
3. Update UI when fresh data arrives
4. Handle offline scenarios gracefully

**Trade-offs**:

- ✅ Better UX (instant loading)
- ✅ Works offline
- ❌ Potential stale data display
- ❌ Additional complexity

### 3. Error Handling Hierarchy

```
AppException (base)
├── NetworkException
├── ValidationException
├── StorageException
└── ParseException
```

### 4. State Management Pattern

**States**: `initial` → `loading` → `loaded/error/empty`
**Benefits**: Clear state transitions, easy to test, predictable UI updates

## Performance Considerations

### Memory Management

- Lazy loading of detail screens
- Proper disposal of providers and controllers
- Image caching (if images were added)

### Search Optimization

- Debounced search (500ms) to prevent excessive filtering
- Case-insensitive search with normalization
- Search across multiple fields (name, location)

### Storage Efficiency

- JSON serialization for local storage
- Minimal data structure to reduce storage size
- Automatic cleanup of old cache (future enhancement)

## Testing Strategy

### Unit Tests

- Business model validation
- Data normalization functions
- Provider state transitions
- Repository data transformation

### Widget Tests

- BaseCard rendering with different data types
- Error state widgets
- Loading states
- Search functionality

### Integration Tests

- End-to-end business list loading
- Offline/online state transitions
- Search and navigation flow

## Known Limitations & Technical Debt

### Current Limitations

1. **No pagination**: All data loaded at once (acceptable for small dataset)
2. **Basic search**: No advanced filtering or sorting
3. **No data sync**: No conflict resolution for simultaneous edits
4. **Limited validation**: Basic phone/email validation only

### Technical Debt

1. **Hardcoded strings**: Should use l10n for internationalization
2. **Basic error messages**: Could be more user-friendly and actionable
3. **No analytics**: No tracking of user interactions or errors
4. **No performance monitoring**: No metrics for load times or errors

## Future Improvements (Given More Time)

### Architecture Enhancements

1. **Riverpod Migration**: Better provider composition and testing
2. **Bloc Implementation**: For more complex state management needs
3. **Clean Architecture**: Full separation of data/domain/presentation layers
4. **Dependency Injection**: Use get_it for better testability

### Feature Additions

1. **Advanced Search**: Filters, sorting, fuzzy search
2. **Favorites**: Local favorites with sync capability
3. **Maps Integration**: Location-based features
4. **Offline Queue**: Queue actions for when back online
5. **Push Notifications**: For business updates

### Technical Improvements

1. **Image Caching**: Efficient image loading and caching
2. **Database Migration**: SQLite/Hive for better local storage
3. **Background Sync**: Periodic data refresh
4. **Error Analytics**: Crash reporting and error tracking
5. **Performance Monitoring**: Load time and memory usage tracking

### UX/UI Enhancements

1. **Skeleton Loading**: Better loading states
2. **Pull-to-Refresh**: More intuitive refresh mechanism
3. **Animations**: Smooth transitions between states
4. **Accessibility**: Screen reader support, high contrast themes
5. **Dark Mode**: Theme switching capability

## Performance Metrics

### Target Metrics

- App startup: < 1 second to first meaningful paint
- List scroll: 60fps smooth scrolling
- Search response: < 100ms for local search
- Offline capability: 100% feature availability when cached

### Monitoring Points

- Provider rebuild frequency
- JSON parsing time
- Local storage read/write times
- Memory usage patterns
- UI thread blocking incidents

## Security Considerations

### Current Implementation

- Basic input validation
- No sensitive data exposure
- Local storage encryption (basic)

### Future Considerations

- API authentication tokens
- Certificate pinning for API calls
- Secure storage for sensitive data
- Input sanitization for search queries

---

## Development Process Notes

### Commit Strategy

Each commit represents a working state of the application with specific focus:

1. **Scaffold**: Project structure and dependencies
2. **State**: Core business logic and state management
3. **Networking**: Data fetching and persistence
4. **UI**: User interface and components
5. **Polish**: Final refinements and documentation

### Code Quality Measures

- Consistent naming conventions
- Proper error handling at all layers
- Comprehensive documentation
- Clean separation of concerns
- Reusable component design

This architecture balances simplicity with extensibility, providing a solid foundation for future growth while meeting all current requirements efficiently.
