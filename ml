#! /home/work/php7/bin/php
<?php

$opts = getopt('p:msa:h');
if ($argc < 2 || isset($opts['h'])) {
    help();
}

$apps = array(
    'db1' => port1,
    'db2' => port2,
);

$ips = array(
    'master' => '192.168.0.1',
    'slave' => '192.168.0.2',
    'db2'=>'192.168.0.3:uname:pwd',
);

// get the port
if (isset($opts['p'])) {
    $port = intval($opts['p']);
} else if (isset($opts['a'])) {
    if (!isset($apps[$opts['a']])) {
        die('app not found:'.$opts['a']);
    }
    $port = $apps[$opts['a']];
    $dbName = $opts['a'];
} else {
    die('port not supplied');
}

// get the mode
$mode = 'master';
if (isset($opts['s'])) {
    $mode = 'slave';
}

if(in_array($dbName, isset($ops[$dbName]))) {
    $mode = $dbName;
}

$ip = $ips[$mode];

$user = 'root';
$pwd = 'root';
$ipAr = explode(':',$ip);
if(count($ipAr)==3)
{
    $ip = $ipAr[0];
    $user = $ipAr[1];
    $pwd = $ipAr[2];
}

$cmd = "mysql -u$user -p$pwd -h $ip --port $port";
$pid = pcntl_fork();
if ($pid) {
    pcntl_wait($status);
    echo "exit status:".$status."\n";
    exit();
} else {
    echo "start mysql...\n";
    pcntl_exec('/usr/bin/mysql', array(
       "-u$user",
       "-p$pwd",
       '-h',
       $ip,
       '--port',
       $port
    ));
    exit(0);
}


function help()
{
    echo <<<HELP
ml
  -p 端口号，如果不给出此参数，可以通过-a指定模块
  -a 模块名，如果没有指定-p，则通过此参数决定使用哪个端口的库
    * db1 库1
    * db2 库2
  -m 主库模式, 即选择master库
  -s 从库模式，即选择slave库
  -h 显示此文档

HELP;
    exit();
}
