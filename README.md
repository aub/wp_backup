# WpBackup

WpBackup is a simple command-line tool for backing up Wordpress sites and their
databases to S3. It uses mysqldump to create a database drop and then copies
either the entire site from your wordpress directory or specific paths. The operation
is entirely configurable by a simple file.

## <a name="installation"></a>Installation

    gem install wp_backup

## <a name="usage"></a>Usage

You'll now have acceess to the wp_backup command. Try "wp_backup help" to get a list of available tasks.

## <a name="copyright"></a>Copyright
Copyright (c) 2012 Aubrey Holland
See [LICENSE][] for details.

[license]: https://github.com/aub/tumble/blob/master/LICENSE.md
