# Validate Readme Spacing
[![Testing](https://github.com/pantheon-systems/validate-readme-spacing/actions/workflows/test.yml/badge.svg)](https://github.com/pantheon-systems/validate-readme-spacing/actions/workflows/test.yml) [![MIT License](https://img.shields.io/github/license/pantheon-systems/validate-readme-spacing)](https://github.com/pantheon-systems/validate-readme-spacing/blob/main/LICENSE)

A GitHub Action that validates the heading section of your plugin's README.MD has newlines handled correctly.

When writing markdown, two spaces are required at the end of a line to preserve single line breaks in the rendered view. Some people's (@jazzsequence) IDEs helpfully remove these and the diff can be missed in GitHub's PR view.

## Input
### `filepath`
The path to the project's README file. Defaults to `README.md`.

## Example Usage 

``` yaml
uses: pantheon-systems/validate-readme-spacing@v1
with:
  filepath: 'README.md'
```