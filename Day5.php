<?php
$filename = 'resource/day5/test.txt';

if (file_exists($filename)) {
    $content = file_get_contents($filename);
    echo $content;
} else {
    echo "File does not exist.";
}
?>