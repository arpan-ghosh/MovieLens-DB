 
</html>
    <body>
        <?php

        	//$movie = $_POST["movie"];    //get the user input 

            include 'open.php'; //$mysqli = new mysqli("INSERT IP ADDRESS HERE", "root", "USERNAME", "PASSWORD");
            $mysqli->multi_query("CALL StoredProcedures();");        //Execute the query with the input. 

            $res = $mysqli->store_result();

            if ($res) {
                echo "<table border=\"1px solid black\">";                              // The procedure executed successfully.
                $first_row = true;
                while($row = $res->fetch_assoc()){
                    If($first_row){
                        $first_row = false;

                        echo '<tr>';
                        foreach($row as $cname =>$cvalue){
                                echo '<th>' .htmlspecialchars($cname) . '</th>';
                        }
                        echo '<tr>';
                    }
                    echo '<tr>';
                    foreach($row as $cname => $cvalue){
                        echo '<th>' .htmlspecialchars($cvalue) . '</th>';
                    }
                    echo '</tr>';
                }

                echo "</table>";
                $res->free();                                                                           // Clean-up.
            } else {
                printf("<br>Error: %s\n", $mysqli->error);                              // The procedure failed to execute.
            }

            $mysqli->close(); 
        ?>
    </body>
</html>