#!/usr/bin/perl
$i = 0;
$myurl = "http://my-stream/hls/m3u8";
#vlc -I dummy <url>
@cmdline = ("/usr/bin/vlc", "");
for( $i = 1; $i <= 100; $i++ )
{
if( $pid = fork )
{
    # parent - ignore
}
elsif( defined $pid )
{
    $cmdline[1] = sprintf "%s:%d", $myurl, $i;
    exec(@cmdline);
}
# elseif - do more error checking here
}