<?php

    include 'conf.php';

    $mysqli = new mysqli($dbhost,$dbuser,$dbpass,$dbname);



    if (!$mysqli || $mysqli->connect_errno) {

	echo 'ERROR:' . $mysqli->connect_errno;

        die ('Error connecting to mysql. :-( <br/>');

    } else {

        #echo 'Yes, we have connected to MySQL! :-) <br/>';

    }

?>



