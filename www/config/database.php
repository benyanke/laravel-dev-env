<?php

// Config DB for non-prod environments on elastic beanstalk

if(!function_exists('setRdsVar')) {
  function setRdsVar($varname, $default = null) {
    if(defined($varname) == false) {
      if( ( ! isset($_SERVER[$varname]) || strlen($_SERVER[$varname]) < 1) && $default != null) {
        define($varname, $default);
      } else {
        define($varname, isset($_SERVER[$varname]) ? $_SERVER[$varname] :  '');
      }
    }
  }
}

setRdsVar('RDS_HOSTNAME');
setRdsVar('RDS_READ_HOSTNAME', RDS_HOSTNAME);
setRdsVar('RDS_DB_NAME');
setRdsVar('RDS_USERNAME');
setRdsVar('RDS_PASSWORD');

return [

    /*
    |--------------------------------------------------------------------------
    | Default Database Connection Name
    |--------------------------------------------------------------------------
    |
    | Here you may specify which of the database connections below you wish
    | to use as your default connection for all database work. Of course
    | you may use many connections at once using the Database library.
    |
    */

    'default' => env('DB_CONNECTION', 'mysql'),

    /*
    |--------------------------------------------------------------------------
    | Database Connections
    |--------------------------------------------------------------------------
    |
    | Here are each of the database connections setup for your application.
    | Of course, examples of configuring each database platform that is
    | supported by Laravel is shown below to make development simple.
    |
    |
    | All database work in Laravel is done through the PHP PDO facilities
    | so make sure you have the driver for your particular database of
    | choice installed on your machine before you begin development.
    |
    */

    'connections' => [

        'mysql' => [
            'driver' => 'mysql',
            'write' => [
                 'host' => env('DB_HOST', RDS_HOSTNAME),
            ],
            'read' => [
                'host' => RDS_READ_HOSTNAME ?: RDS_HOSTNAME ?: env('DB_READ_HOST', env('DB_HOST', RDS_HOSTNAME)),
            ],
            'port' => env('DB_PORT', '3306'),
            'database' => env('DB_DATABASE', RDS_DB_NAME),
            'username' => env('DB_USERNAME', RDS_USERNAME),
            'password' => env('DB_PASSWORD', RDS_PASSWORD),
            'unix_socket' => env('DB_SOCKET', ''),

            'charset'   => 'utf8',
            'collation' => 'utf8_unicode_ci',
            //'charset' => 'utf8mb4',           'collation' => 'utf8mb4_unicode_ci',
            'prefix' => '',
            'strict' => true,
            'engine' => null,
            'sticky' => true,
        ],


    ],

    /*
    |--------------------------------------------------------------------------
    | Migration Repository Table
    |--------------------------------------------------------------------------
    |
    | This table keeps track of all the migrations that have already run for
    | your application. Using this information, we can determine which of
    | the migrations on disk haven't actually been run in the database.
    |
    */

    'migrations' => 'migrations',

    /*
    |--------------------------------------------------------------------------
    | Redis Databases
    |--------------------------------------------------------------------------
    |
    | Redis is an open source, fast, and advanced key-value store that also
    | provides a richer set of commands than a typical key-value systems
    | such as APC or Memcached. Laravel makes it easy to dig right in.
    |
    */

    'redis' => [

        'client' => 'predis',

        'default' => [
            'host' => env('REDIS_HOST', '127.0.0.1'),
            'password' => env('REDIS_PASSWORD', null),
            'port' => env('REDIS_PORT', 6379),
            'database' => 0,
        ],

    ],

];
