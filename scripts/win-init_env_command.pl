use strict;
use warnings;
use Cwd;

my $CurrentDirectory = cwd();

package Env;

my $ARGNb = 0;
my $ARG = "";

if(@ARGV > 0)
{
    $ARGNb = @ARGV;
    $ARG = $ARGV[0];
}

####################################################################################### UTILITY DIRECTORIES
our $PBase         = $CurrentDirectory . "/../";
our $SWDist        = $PBase . "dist/";
$ENV{SW_DIST}      = $SWDist;
our $SWScripts     = $CurrentDirectory . "/";
our $SWDistLIB     = $SWDist . "lib/";
our $PThird_party  = $PBase . "../thirdParty/";


####################################################################################### CHECK CUDA PATH


if (length($ENV{CUDA_PATH}) > 1)
{
    $ENV{CUDA_FOUND} = "yes";
}
else
{
    $ENV{CUDA_FOUND} = "no";
}

####################################################################################### SET PROJECTS TO BUILD
our $Contour   = "contour";

# add projects to build here
my @PbuildOrder            = ($Contour);

sub buildOrder {
    return @PbuildOrder;
}

# executables scripts to be generated for each project
my @ExecScriptParams = (# city
                        "contour",           "x86",  "Contour.exe",
                        "contour-cv",        "x86",  "Contour-cv.exe",
                        "contour-x64",       "amd64","Contour-x64.exe",
                        "contour-cv-x64",    "amd64","Contour-cv-x64.exe",


);

sub executablesNumber {
    my $size = $#ExecScriptParams+1;
    return ($size / 3);
};

sub commandFileName {
    my ($num) = @_;
    return $ExecScriptParams[($num * 3)];
};

sub archExe {
    my ($num) = @_;
    return $ExecScriptParams[(1 + $num * 3)];
};

sub exeFileName {
    my ($num) = @_;
    return $ExecScriptParams[(2 +$num * 3)];
};

####################################################################################### SET 3RD PARTY SOFTWARE PATH
##################### SDL
$ENV{THIRD_PARTY_SDL}       = $PThird_party . "SDL/1.2.5/";
$ENV{THIRD_PARTY_SDL_64}    = $PThird_party . "SDL/1.2.5/x64/";
$ENV{THIRD_PARTY_SDL_INC}   = $PThird_party . "SDL/1.2.5/include";
##################### GLUT
$ENV{THIRD_PARTY_GLUT}      = $PThird_party . "freeglut/";
$ENV{THIRD_PARTY_GLUT_64}   = $PThird_party . "freeglut/x64/";
$ENV{THIRD_PARTY_GLUT_INC}  = $PThird_party . "freeglut/include";
##################### QT
$ENV{THIRD_PARTY_QT}      = $PThird_party . "Qt/4.8.3/";
$ENV{THIRD_PARTY_QT_64}   = $PThird_party . "Qt/x64/4.8.3/";
$ENV{THIRD_PARTY_QT_INC}  = $PThird_party . "Qt/4.8.3/include";
##################### OPENCV
$ENV{THIRD_PARTY_OPENCV}   = $PThird_party . "opencv/opencv-2.49/";
$ENV{THIRD_PARTY_OPENCV_64}= $PThird_party . "opencv/x64/opencv-2.48/";

our $CurrentPath = $ENV{PATH};

my $PathsToAdd = ";";

$PathsToAdd = $ENV{THIRD_PARTY_QT} . "bin/;" . $PathsToAdd;

####################################################################################### x86 PATHS
if($ARG eq "x86")
{
    # SDL
    $PathsToAdd = $ENV{THIRD_PARTY_SDL} . "lib/;" . $PathsToAdd;
    $PathsToAdd = $ENV{THIRD_PARTY_SDL} . "bin/;" . $PathsToAdd;
    # GLUT
    $PathsToAdd = $ENV{THIRD_PARTY_GLUT} . "bin/;" . $PathsToAdd;
    $PathsToAdd = $ENV{THIRD_PARTY_GLUT} . "lib/;" . $PathsToAdd;
    # Opencv
    $PathsToAdd = $ENV{THIRD_PARTY_OPENCV} . "build/bin/Release;" . $PathsToAdd;
    $PathsToAdd = $ENV{THIRD_PARTY_OPENCV} . "build/bin/Debug;" . $PathsToAdd;
    # Qt
    $PathsToAdd = $ENV{THIRD_PARTY_QT} . "bin/;" . $PathsToAdd;
    $PathsToAdd = $ENV{THIRD_PARTY_QT} . "lib/;" . $PathsToAdd;
}

####################################################################################### amd64 PATHS
if($ARG eq "amd64")
{
    # SDL
    $PathsToAdd = $ENV{THIRD_PARTY_SDL_64} . "bin/;" . $PathsToAdd;
    $PathsToAdd = $ENV{THIRD_PARTY_SDL_64} . "lib/;" . $PathsToAdd;
    # GLUT
    $PathsToAdd = $ENV{THIRD_PARTY_GLUT_64} . "bin/;" . $PathsToAdd;
    $PathsToAdd = $ENV{THIRD_PARTY_GLUT_64} . "lib/;" . $PathsToAdd;
    # Opencv
    $PathsToAdd = $ENV{THIRD_PARTY_OPENCV_64} . "build/bin/Release/;" . $PathsToAdd;
    $PathsToAdd = $ENV{THIRD_PARTY_OPENCV_64} . "build/bin/Debug/;" . $PathsToAdd;
    # Qt
    $PathsToAdd = $ENV{THIRD_PARTY_QT_64} . "lib/;" . $PathsToAdd;
    $PathsToAdd = $ENV{THIRD_PARTY_QT_64} . "bin/;" . $PathsToAdd;
}

####################################################################################### UPDATE GLOBAL PATH


$ENV{PATH} = $PathsToAdd . $ENV{PATH};
