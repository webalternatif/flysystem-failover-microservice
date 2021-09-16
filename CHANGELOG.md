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
