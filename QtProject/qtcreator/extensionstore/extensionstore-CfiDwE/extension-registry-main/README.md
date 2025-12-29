# The Registry

[![Number of Extensions](./badges/extensions.svg)](./badges/extensions.svg)
[![Status of CI validation](https://github.com/qt-creator/extension-registry/actions/workflows/validate.yml/badge.svg)](https://github.com/qt-creator/extension-registry/actions/workflows/validate.yml)
[![Status of CI Hash validation](https://github.com/qt-creator/extension-registry/actions/workflows/check-hash.yml/badge.svg)](https://github.com/qt-creator/extension-registry/actions/workflows/check-hash.yml)



This contains a registry of Qt Creator extensions.

## How to include your plugin

1. Fork this repository
2. Add a new folder in the `registry` folder with the name `<vendorid>.<pluginid>`
3. Find the metadata `Extension.json` that was generated from your `Extension.json.in` file from within your Extensions build folder. For Lua plugins you can use the main plugin lua file instead.
4. Add your extension to the registry using `node scripts/new.js registry/<vendorid>.<pluginid>/extension.json <buildfolder/Extension.json>`. This will create a new folder with the name `<vendorid>.<pluginid>` and create the `extension.json` based on your extension in it.
  (You can also specify your lua entry script path instead)
5. Fill in the `sources` array in the newly created `extension.json` file with the urls to your Extension.
6. Run `git add .` and `git commit -m "Added <your-plugin-id>"`
7. Push your changes to your fork
> To test your changes, you can add your fork in Qt Creator under "Settings => Extensions => Repository URLs". Specify the path to your Repositories tar.gz file, e.g. `https://github.com/<your-username>/extension-registry/archive/refs/heads/<your-branch-name>.tar.gz`
9. Create a pull request to this repository
10. Wait for approval

## Fixing / setting SHA keys

To ease adding new versions of plugins, you can run the script
`node scripts/fixhashes.js <path/to/your/extension.json>`.
This will calculate the sha256 hash of the sources and update the
`sha256` key in the `sources` object.

## Distribution

This repo contains a `.gitattributes` file that excludes folders from
a call to `git archive`. This is used to create a zip file of the registry
for distribution. The following command will create a zip file of the registry
without the unecessary folders:

```bash
git archive --format=zip HEAD -o registry.zip
```

Conveniently, GitHubs "Download ZIP" feature honors the `.gitattributes` file
and will create a zip file of the registry without the unecessary folders.
