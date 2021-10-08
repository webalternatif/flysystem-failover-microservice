## v0.1.2 (unreleased)

### ✨ New features

* Add `NB_MSG_PER_WORKER` environment variable to configure the number of messages a worker will process in a single execution
* Add `USER_ID` and `GROUP_ID` environment variables to set UID and GID of user executing commands inside the container (useful when using `local://`) 
* Bump `webalternatif/flysystem-dsn-bundle` to `^0.3.2` to be able to use `local://` storage DSN

## v0.1.1 (September 16, 2021)

### 🔒 Security issues fixes

  * Remove default `APP_SECRET` and generate it if needed in entrypoint

### ✨ New features

  * Add support for MySQL and PostgreSQL as message storage

### ⚡ Performance improvements

  * Increase worker processing message limit from 1 to 10

### 🐛 Bug fixes

  * Bump `webalternatif/flysystem-failover-bundle` to `^0.2.1` to fix issues when using SQLite

## v0.1.0 (September 15, 2021)

First version.
