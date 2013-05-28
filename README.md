cron-wrapper-script
===================

Shell script wrapper to ensure that only one instance of another file/program runs.

Example use from cron, for a PHP script:

    * * * * * /path/to/this/script/wrapper.sh /path/to/other/script.php > /dev/null


Make the PHP file executable and add the following hash bang line at the start

    #!/usr/bin/php