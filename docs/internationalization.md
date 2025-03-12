# Adding Languages

- Checkout repository
- Make sure development environment is set up correctly for your OS
- Create a new translation file by running
  ```shell
  just add-translation <locale>  # just add-translation fr_FR
  ```
- New `<locale>.ts` file appears in the `i18n` directory
- Translate the `ts` file using Qt Linguist 6
- To test the translation:
  - Add a new entry in the `MyAppLanguageModel.qml` file
  - Run
    ```shell
    just build-develop
    ```
