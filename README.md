# Fetch Release Asset

This GitHub action downloads an asset from a Github release. Private repos are supported. Forked from [dsaltares/fetch-gh-release-asset](https://github.com/dsaltares/fetch-gh-release-asset), changes make to support installing binary to path (no longer running in Docker).

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

