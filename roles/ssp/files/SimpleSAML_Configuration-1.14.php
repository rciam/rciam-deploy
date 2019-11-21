#!/usr/bin/env php
<?php
/*
 * Script to retrieve the supplied string configuration option from the given
 * SimpleSAMLphp installation.
 *
 * An exception will be thrown if this option isn't a string, or if this option
 * isn't found, and no default value is given.
 *
 * @author Nicolas Liampotis (GRNET)
 */

/* This is the base directory of the SimpleSAMLphp installation. */
$baseDir = $argv[1];

/* This is the name of the configuration option whose value to retrieve. */
$configParam = $argv[2];

try {
  /* Add library autoloader. */
  require_once($baseDir . '/lib/_autoload.php');

  echo \SimpleSAML_Configuration::getInstance()->getString($configParam);
} catch (Exception $e) {
  // Do nothing
}
?>
