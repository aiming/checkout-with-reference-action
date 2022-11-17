# GitHub Action checkout with reference parameter
GitHub Actions上でソースコードをcloneします。referenceを指定できるようにしています。

NFS等でリファレンス用のリポジトリを用意しておくと、ネットワーク転送量の低減や時間の短縮を期待できます。
リファレンスリポジトリについては [git](https://git-scm.com/docs/git-clone/ja) の `--reference` パラメータや、
https://swet.dena.com/entry/2021/07/12/120000 を参照してください。

# Usage

```yaml
- uses: aiming/checkout-with-reference-action@v1
  with:
    # https://github.com/aiming/checkout-with-reference-action.git の **aiming/checkout-with-reference-action** の部分です。
    # Default: ${{ github.repository }}
    github_repository: ''

    # Private repositoryの時、GitHubActionsより渡されるtokenを渡します
    # Default: ${{ github.token }}
    github_token: ''

    # Private repositoryの時、GitHubActionsより渡されるactorを渡します
    # Default: ${{ github.actor }}
    github_actor: ''

    # cloneするブランチ名を指定します。通常は指定なしです
    branch_name: ''

    # cloneするcommit shaを指定します。
    # Default: ${{ github.sha }}
    sha: ${{ github.sha }}

    # リファレンス先の clone 済みのディレクトリを指定します。
    reference_dir: '/mnt/shared_dir_like_as_nfs/repository.git'

    # clone時にLFSのデータをfetchするかどうかを指定します
    # 大体のケースで clone後に自前で git lfs pull したほうが早いです
    fetch_lfs: false

    # checkout先のディレクトリ名を指定します
    checkout_dir: .

    # fetch時に発生するdetected dubious ownership in repositoryを抑制する。(git config safe.directoryを設定します)
    # Default: true
    ignore_dubious_ownership: true
```

# Example

リファレンスリポジトリ( `/mnt/shared_dir_like_as_nfs/repository.git` に存在する)付きで、カレントディレクトリにcheckoutします

```yaml
- uses: aiming/checkout-with-reference-action@v1
  with:
    reference_dir: '/mnt/shared_dir_like_as_nfs/repository.git'
    checkout_dir: .
```

プライベートリポジトリをcheckoutします

```yaml
- uses: aiming/checkout-with-reference-action@v1
  with:
    github_token: ${{ github.token }}
    github_actor: ${{ github.actor }}
    github_repository: ${{ github.repository }}
    reference_dir: '/mnt/shared_dir_like_as_nfs/repository.git'
    checkout_dir: .
```

ブランチ名指定でcheckoutします

```yaml
- uses: aiming/checkout-with-reference-action@v1
  with:
    branch_name: 'main'
    reference_dir: '/mnt/shared_dir_like_as_nfs/repository.git'
    checkout_dir: .
```
