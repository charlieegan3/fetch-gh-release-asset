# Fetch GH Release Asset

This action downloads an asset from a Github release. Private repos are supported.

## Inputs

### `repo`

The `org/repo`. Defaults to the current repo.

### `version`

The release version to fetch from. Default `"latest"`. If not `"latest"`, this has to be in the form `tags/<tag_name>` or `<release_id>`.

### `file`

**Required** The name of the file in the release.

### `target`

Optional target file path. Only supports paths to subdirectories of the Github Actions workspace directory

### `token`

Optional Personal Access Token to access repository. You need to either specify this or use the ``secrets.GITHUB_TOKEN`` environment variable. Note that if you are working with a private repository, you cannot use the default ``secrets.GITHUB_TOKEN`` - you have to set up a [personal access token with at least the scope org:hook](https://github.com/dsaltares/fetch-gh-release-asset/issues/10#issuecomment-668665447).

### `chmod_x`

Make the downloaded file executable

## Outputs

### `version`

The version number of the release tag. Can be used to deploy for example to itch.io

## Example usage

```yaml
uses: dsaltares/fetch-gh-release-asset@master
with:
  repo: "dsaltares/godot-wild-jam-18"
  version: "latest"
  file: "plague-linux.zip"
  target: "subdir/plague-linux.zip"
  token: ${{ secrets.YOUR_TOKEN }}
```

## Support

This action only supports Linux runners as this is a [docker container](https://docs.github.com/en/actions/creating-actions/about-actions#types-of-actions) action. If you encounter `Error: Container action is only supported on Linux` then you are using non-linux runner.
