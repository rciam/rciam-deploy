#!/usr/bin/env php
<?php
/*
 * Script to generate password hashes.
 *
 */

/* This is the base directory of the simpleSAMLphp installation. */
$baseDir = $argv[1];

/* Add library autoloader. */
require_once($baseDir . '/lib/_autoload.php');

$password = $argv[2];

$algo = 'sha256';

echo \SimpleSAML\Utils\Crypto::pwHash($password, strtoupper( 'S' . $algo ) );
