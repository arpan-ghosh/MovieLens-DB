<!DOCTYPE HTML>
<!--
    Final Project 600.315: jlee562/aghosh17
-->
<html>

    <head>
        <title>MovieLens Database</title>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <!--[if lte IE 8]><script src="assets/js/ie/html5shiv.js"></script><![endif]-->
        <link rel="icon" type="image/png" href="https://www.articleonepartners.com/wp-content/uploads/2015/06/1000px-Clapboard.svg_.png" /> 
        <link rel="stylesheet" href="assets/css/main.css" />
        <!--[if lte IE 8]><link rel="stylesheet" href="assets/css/ie8.css" /><![endif]-->
        <!--[if lte IE 9]><link rel="stylesheet" href="assets/css/ie9.css" /><![endif]-->
    </head>
    <body class="loading">
        <div class="fullscreen-bg">
    <!-- <video loop muted autoplay poster="assets/video.mp4" class="fullscreen-bg__video">
        <source src="assets/video.mp4" type="video/mp4">
        <source src="assets/video.mp4" type="video/mp4">
        <source src="assets/video.mp4" type="video/mp4">
    </video> -->
</div>      
        <div id="wrapper">
            <div id="overlay"></div>
            <div id="main">
        <!-- Header -->


                    <header id="header">
                        <h1>Number of Tags</h1>
                        <A HREF = "http://www.arpanghosh.com/cs315">Click to Go Back to Home</A> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <A HREF = "http://www.arpanghosh.com/cs315/other.html">Click to Go Back to Other</A>
                        <p> Number of Tags That Exist For Your Searched Movie &nbsp;&nbsp;
            </p>

            <b><p>
            <div align =middle>
        <div style="height:500px;width:1000px;border:1px solid #ccc;font:16px/26px Georgia, Garamond, Serif;overflow:auto;">
        <?php
            include 'open.php';
            $movie = $_POST["movie"];                                             // Get 

            $mysqli->multi_query("CALL numTags('".$movie."');");        //Execute the query with the input. (AllRawScores)
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
        </div>
     </div>
            </p></b>

          </header>
                <!-- Footer -->
                    <footer id="footer">

                    </footer>
            </div>
        </div>


        <!--[if lte IE 8]><script src="assets/js/ie/respond.min.js"></script><![endif]-->
        
        <script language="JavaScript">
            window.onload = function() { document.body.className = ''; }
            window.ontouchmove = function() { return false; }
            window.onorientationchange = function() { document.body.scrollTop = 0; }
            /* When the user clicks on the button, 
toggle between hiding and showing the dropdown content */
function myFunction() {
    document.getElementById("myDropdown").classList.toggle("show");
}

// Close the dropdown if the user clicks outside of it
window.onclick = function(event) {
  if (!event.target.matches('.dropbtn')) {

    var dropdowns = document.getElementsByClassName("dropdown-content");
    var i;
    for (i = 0; i < dropdowns.length; i++) {
      var openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
}
        </script>
    </body>
</html>