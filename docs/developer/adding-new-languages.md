# Adding a new language

* Checkout repository
* Make sure application builds correctly
* Create a new translation file by running
  ```shell
  make create-new-translation lang=<locale>
  ```
  while `<locale>` is the locale for the language to add
* Update all possible translations by running
  ```shell
  make update-translations
  ```
* New `<locale>.ts` file should appear in the `i18n` directory
* Translate the `ts` file using Qt Linguist 6
* To test the translation:
  * Add a new entry in the `MyAppLanguageModel.qml` file
  * Run
    ```shell
    make develop-build
    ```
