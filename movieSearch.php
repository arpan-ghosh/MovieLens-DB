<html>
    <body>
        <?php
            include 'open.php';
            $movie = $_POST["movie"];                                             // Get 

            $mysqli->multi_query("CALL SearchMovie('".$movie."');");        //Execute the query with the input. (AllRawScores)
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
            $mysqli->close();                                                                           // Clean-up.
        ?>
    </body>
</html>

