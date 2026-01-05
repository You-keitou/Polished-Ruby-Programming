# OSS Patterns & Reference Code

This file maps "Polished Ruby Programming" concepts to real-world Open Source examples found via analysis.

## Chapter 1: Core Classes
*Objective: Mastering built-ins.*

| Topic | Reference Gem | Context/Pattern |
|-------|---------------|-----------------|
| **Comparisons/State** | `ActiveSupport` (Rails) | Extends core classes (`String#pluralize`, `Time#advance`). Shows when to monkey-patch vs wrapper. |
| **Structs/Data** | `Dry-Struct` / `Dry-Types` | Advanced usage of typed structs, going beyond standard `Struct`. |
| **Symbols vs Strings** | `RuboCop` | Heavily uses Symbols for internal token representation (AST) for performance and immutability. |
| **Collections** | `Hamster` / `Concurrent-Ruby` | Immutable collections and thread-safe array/hash implementations. |

## Chapter 2: Custom Classes & SOLID
*Objective: designing maintainable objects.*

| Topic | Reference Gem | Context/Pattern |
|-------|---------------|-----------------|
| **SRP** | `Pundit` | "Policy" objects. Each class does one thing: authorizes one user for one resource action. |
| **Composition** | `Rack` | Middleware architecture. Each middleware class handles one aspect (logging, auth) and passes to the next. |
| **Value Objects** | `Money` gem | Encapsulates logic (currency, arithmetic) in a custom class rather than using raw Floats/BigDecimals. |

## Chapter 3: Variables & Scope
*Objective: Managing state safely.*

| Topic | Reference Gem | Context/Pattern |
|-------|---------------|-----------------|
| **Constants** | `Sidekiq` | Uses frozen constants for scripts and default configuration to prevent mutation issues in threaded envs. |
| **Local Vars** | `RSpec` | Encourages `let` (memoized helper) but heavily relies on block-local variables in `it` blocks for isolation. |

## Chapter 4: Methods
*Objective: Clear interfaces.*

| Topic | Reference Gem | Context/Pattern |
|-------|---------------|-----------------|
| **Keyword Args** | `ViewComponent` | Heavily uses keyword arguments for component initialization to make rendering templates clear. |
| **Visibility** | `Devise` | Strict use of `private`/`protected` in controllers and helpers to expose only safe public APIs. |

## Chapter 5: Handling Errors
*Objective: Resilience.*

| Topic | Reference Gem | Context/Pattern |
|-------|---------------|-----------------|
| **Custom Exceptions** | `Faraday` | Defines a clear hierarchy (`Faraday::Error` -> `Faraday::ConnectionFailed`), allowing precise rescuing. |
| **Resilience** | `Sidekiq` | Job retry mechanism (exponential backoff) implemented in `Sidekiq::JobRetry`. |
| **Return vs Raise** | `ActiveModel::Validations` | Returns `false` on `save` (expected failure) vs raising `ActiveRecord::RecordInvalid` on `save!`. |

## Chapter 7-10: Library Design & Metaprogramming
*Objective: Magic vs Clarity.*

| Topic | Reference Gem | Context/Pattern |
|-------|---------------|-----------------|
| **DSL** | `RSpec` | The gold standard for internal DSL (`describe`, `it`, `expect`). Uses `instance_eval` and blocks extensively. |
| **Configuration** | `Kaminari` / `Devise` | `config.setup do |config| ... end` pattern. |
| **Metaprogramming** | `FactoryBot` | Dynamic definition of factories. Uses `method_missing` to map attributes to setters. |
| **Hooks/Plugins** | `Pluggy` / `RSpec` | Hook systems allows users to inject behavior before/after lifecycle events. |

## Chapter 11: Testing
*Objective: Verification.*

| Topic | Reference Gem | Context/Pattern |
|-------|---------------|-----------------|
| **Mocks/Stubs** | `Mocha` / `RSpec Mocks` | Reference for implementation of test doubles. |
| **Integration** | `Capybara` | Abstraction of browser interactions for high-level testing. |

---

## How to use this reference
When generating a problem for a specific Item:
1.  Look up the Chapter/Topic here.
2.  Find the **Reference Gem**.
3.  Use `query-docs` or GitHub search to find the specific implementation in that gem.
4.  Base the problem on a simplified version of that real-world scenario.