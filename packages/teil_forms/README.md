# Teil Forms

`Teil Forms` is a lightweight and flexible solution for handling forms in Flutter apps.
Providing a powerful approach to form management. Designed to be `type safe`, `headless` and `extendable`.
It allows you to focus on building your UI while `Teil Forms` takes care of the form management.

## Motivation

When building forms in Flutter usually you have to use [Form](https://api.flutter.dev/flutter/widgets/Form-class.html) and [FormField](https://api.flutter.dev/flutter/widgets/FormField-class.html) widgets to manage the form combined with some state management solution like [ValuNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) or [Bloc](https://bloclibrary.dev/).
This approach can solve simple forms cases but it has some limitations:

- **UI coupled**: The form logic is tightly coupled with the UI.
- **Open-Closed Principle**: Hard to extend `Form` and `FormField` with custom logic.
- **Field dependencies**: You have to write your own logic to handle field dependencies.
- **Error handling**: Need to handle errors manually using `FormFieldState`.
- **Missing features**: No built-in async validation, focus management, dirty checking, reset state, etc.

For this reason, native Flutter forms can become complex and hard to maintain as the form grows.
Other solutions like [flutter_form_builder](https://pub.dev/packages/flutter_form_builder) or [flutter_form_bloc](https://pub.dev/packages/flutter_form_bloc) attempt to address these issues.
However, they still face challenges with type safety, UI coupling, and extensibility.

Expired by these libraries and web forms libraries like [react-hook-form](https://react-hook-form.com/), [formik](https://formik.org/) and [react-final-form](https://final-form.org/react).
`Teil Forms` aims to provide a similar experience in Flutter respecting the **main principles** of these libraries.

- **Type safety**: Fully typed forms.
- **Headless**: UI agnostic, you can build your UI with any widget.
- **Extendable**: Easily extend the form with custom logic.
- **Testable**: Easy to test your form logic.

## Features

- Field value control.
- Validation (sync and async).
- Focus management.
- Form submission handling.
- Dirty field checking.
- Reset or clear functionality.

## Installation

Add `teil_forms` dependency to your `pubspec.yaml`

```bash
dart pub add teil_forms
```

## Changelog

See [Changelog](./CHANGELOG.md) for more details.
