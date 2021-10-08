# Flysystem Failover Microservice

[![Source code](https://img.shields.io/badge/source-GitHub-blue)](https://github.com/webalternatif/flysystem-failover-microservice)
[![Software license](https://img.shields.io/github/license/webalternatif/flysystem-failover-microservice)](https://github.com/webalternatif/flysystem-failover-microservice/blob/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/webalternatif/flysystem-failover-microservice)](https://github.com/webalternatif/flysystem-failover-microservice/issues)

This microservice is a Symfony application that allows to synchronize files
between multiple storages.

## How it works

*TODO...*

## Usage (docker image)

```bash
$ docker run -it \
    --env 'STORAGES=dsn1://,dsn2://,...' \
    webalternatif/flysystem-failover
```

The `STORAGES` environment variable is mandatory, it lists storages you want to
synchronize in the form of DSN separated by commas.

See [available adapters][1] section of `webalternatif/flysystem-dsn` to know
what DSN you can use (all except `failover`).

### Environment variables

| Name                     | Description                                                                                                                          | Default value                                  |
|--------------------------|--------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------|
| `DATABASE_URL`           | Doctrine database connection URL. See [Doctrine documentation][2]. Only `sqlite`, `mysql` and `pgsql` are supported.                 | `sqlite:///%kernel.project_dir%/var/db.sqlite` |
| `DISABLE_SCAN`           | Disable the scanner process.                                                                                                         | `false`                                        |
| `NB_MSG_PER_WORKER`      | Number of messages a worker will process in a single execution. `-1` for unlimited                                                   | `10`                                           |
| `NB_WORKERS`             | Number of workers to process messages.                                                                                               | `1`                                            |
| `SCAN_INTERVAL`          | Minimal duration in seconds between two scans (there is only one scan at a time).                                                    | `300`                                          |
| `STORAGES`               | Comma-separated DSN list of storages to synchronize. See [available DSN][1].                                                         | *required*                                     |
| `USER_ID` and `GROUP_ID` | If both defined, those values are used as UID and GID of user executing commands inside the container. Useful when using `local://`. | `82` and `82`                                  |

[1]: https://github.com/webalternatif/flysystem-dsn#adapters
[2]: https://www.doctrine-project.org/projects/doctrine-dbal/en/latest/reference/configuration.html#connecting-using-a-url
