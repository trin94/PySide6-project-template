# Adding a New Language

1. **Clone the repository** and ensure your development environment is set up for your operating system.

2. **Create a new translation file** by running:

   ```shell
   just add-translation <locale>  # Example: just add-translation fr-FR
   ```

   This generates a new `<locale>.ts` file in the `i18n` directory.

3. **Translate the `.ts` file** using [Qt Linguist 6](https://doc.qt.io/qt-6/linguist-translators.html).

4. **Test your translation**:

   - Add a new entry for the locale in `MyAppLanguageModel.qml`.
   - Rebuild the resources:
     ```shell
     just build-develop
     ```
